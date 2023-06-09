data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

module "rg" {
  source = "git::https://github.com/sknaresh2000/terraform-azurerm-resource-group.git?ref=v0.0.1"
  name   = var.resource_group_name
  tags   = module.tags.tags
}

module "tags" {
  source   = "git::https://github.com/sknaresh2000/terraform-azurerm-tags.git?ref=v0.0.1"
  app_name = var.app_name
}

module "key-vault" {
  source                        = "git::https://github.com/sknaresh2000/terraform-azurerm-key-vault.git?ref=v0.0.1"
  rg_name                       = module.rg.name
  name                          = var.kv_name
  tags                          = module.tags.tags
  private_endpoint_subnet_id    = module.subnet["private-endpoint"].id
  public_network_access_enabled = true
  enable_rbac_authorization     = false
  network_acls = {
    bypass_services_info        = "AzureServices"
    default_action              = "Deny"
    allowed_ips                 = [data.http.ip.response_body]
    service_endpoint_subnet_ids = null
  }
  private_dns_zone_info = {
    dns_zone_name = "privatelink.vaultcore.azure.net"
    dns_zone_ids  = [azurerm_private_dns_zone.dns["privatelink.vaultcore.azure.net"].id]
  }
}

module "virtual_network" {
  source        = "git::https://github.com/sknaresh2000/terraform-azurerm-virtual-network.git?ref=v0.0.1"
  address_space = [var.vnet_address_prefix]
  name          = var.vnet_name
  rg_name       = module.rg.name
  tags          = module.tags.tags
}

module "subnet" {
  source         = "git::https://github.com/sknaresh2000/terraform-azurerm-subnets.git?ref=v0.0.1"
  for_each       = var.subnets_info
  address_prefix = each.value.address_prefix
  name           = each.value.name
  vnet_rg_name   = module.rg.name
  vnet_name      = module.virtual_network.name
  nsg_name       = each.value.nsg_info.name
  nsg_rg_name    = module.rg.name
  nsgrules       = each.value.nsg_info.rules
  tags           = module.tags.tags
}

module "AzureBastion" {
  source                = "git::https://github.com/sknaresh2000/terraform-azurerm-bastion.git?ref=v0.0.1"
  name                  = var.bastion_name
  tags                  = module.tags.tags
  resource_group_name   = module.rg.name
  virtual_network_name  = module.virtual_network.name
  subnet_address_prefix = var.bastion_address_prefix
  ip_config_name        = var.bastion_ip_config_name
  pip_name              = var.bastion_pip_name
  nsg_name              = var.bastion_nsg_name
}

module "storage_account" {
  source                                = "git::https://github.com/sknaresh2000/terraform-azurerm-storage-account.git?ref=v0.0.1"
  rg_name                               = module.rg.name
  name                                  = var.sa_name
  tags                                  = module.tags.tags
  private_endpoint_subnet_id            = module.subnet["private-endpoint"].id
  private_endpoint_sa_subresource_names = ["blob"]
  container_info                        = var.sa_containers
  public_network_access_enabled         = true
  network_acls = {
    bypass_services_info        = ["AzureServices"]
    default_action              = "Deny"
    allowed_ips                 = [data.http.ip.response_body]
    service_endpoint_subnet_ids = null
  }
  private_dns_zone_info = {
    dns_zone_name = "privatelink.blob.core.windows.net"
    dns_zone_ids  = [azurerm_private_dns_zone.dns["privatelink.blob.core.windows.net"].id]
  }
}


module "vault-vm" {
  depends_on                      = [module.key-vault]
  source                          = "git::https://github.com/sknaresh2000/terraform-azurerm-linux-virtual-machine.git?ref=v0.0.1"
  for_each                        = var.vault_vm_info
  name                            = each.key
  resource_group_name             = module.rg.name
  size                            = each.value.size
  disable_password_authentication = each.value.disable_password_authentication
  identity_type                   = each.value.identity_type
  os_disk_name                    = each.value.os_disk_name
  os_disk_type                    = each.value.os_disk_type
  os_disk_size_gb                 = each.value.os_disk_size_gb
  source_image_reference          = each.value.source_image_reference
  network_config                  = { for k, v in each.value.nic_config : k => merge(v, { subnet_id = module.subnet["vault"].id }) }
  custom_data_script              = module.vault-init.vault_customdata_base64_encoded
  public_key                      = tls_private_key.tls[each.key].public_key_openssh
  tags                            = module.tags.tags
}

module "vault-init" {
  source            = "./vault-init"
  sa_account_name   = var.sa_name
  sa_container_name = keys(var.sa_containers)[0]
  kv_name           = var.kv_name
  kv_key_name       = var.key_name
  tenant_id         = data.azurerm_client_config.current.tenant_id
  cluster_name      = var.vault_cluster_name
  vault_version     = var.vault_version
}

resource "azurerm_private_dns_zone" "dns" {
  for_each            = toset(var.private_dns_zones)
  name                = each.value
  resource_group_name = module.rg.name
  tags                = module.tags.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet-link" {
  depends_on            = [azurerm_private_dns_zone.dns]
  for_each              = toset(var.private_dns_zones)
  name                  = "${var.vnet_name}-link"
  resource_group_name   = module.rg.name
  private_dns_zone_name = each.value
  virtual_network_id    = module.virtual_network.id
  tags                  = module.tags.tags
}

resource "azurerm_key_vault_key" "vault-key" {
  depends_on   = [azurerm_key_vault_access_policy.access_policies]
  name         = var.key_name
  key_vault_id = module.key-vault.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts     = ["unwrapKey", "wrapKey"]
  rotation_policy {
    automatic {
      time_before_expiry = "P30D"
    }
    expire_after         = "P40D"
    notify_before_expiry = "P29D"
  }
}

resource "tls_private_key" "tls" {
  for_each  = { for k, v in var.vault_vm_info : k => v if v.disable_password_authentication == true }
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "secret" {
  depends_on   = [azurerm_key_vault_access_policy.access_policies]
  for_each     = { for k, v in var.vault_vm_info : k => v if v.disable_password_authentication == true }
  name         = "${each.key}-key"
  value        = tls_private_key.tls[each.key].private_key_openssh
  key_vault_id = module.key-vault.id
}

resource "azurerm_key_vault_access_policy" "access_policies" {
  for_each                = merge(local.vm_keyvault_access_policies, local.tf_access_policies)
  key_vault_id            = module.key-vault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.value.object_id
  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
}

resource "azurerm_role_definition" "vault-role" {
  name        = "vault-azure-role"
  scope       = data.azurerm_subscription.current.id
  description = "This is a custom role created for vault identity"

  permissions {
    actions = [
      "Microsoft.Compute/virtualMachines/*/read",
      "Microsoft.Compute/virtualMachineScaleSets/*/read",
      "Microsoft.ManagedIdentity/userAssignedIdentities/*/read"
    ]
  }
}

resource "azuread_directory_role" "cloudapp-admin" {
  display_name = "Cloud Application Administrator"
}

resource "azuread_directory_role_assignment" "vm_vault_role" {
  for_each            = var.vault_vm_info
  role_id             = azuread_directory_role.cloudapp-admin.template_id
  principal_object_id = module.vault-vm[each.key].principal_id
}

resource "azurerm_role_assignment" "sa_vault_role" {
  for_each             = var.vault_vm_info
  scope                = module.storage_account.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.vault-vm[each.key].principal_id
}

resource "azurerm_role_assignment" "vm_vault_role" {
  for_each             = var.vault_vm_info
  scope                = data.azurerm_subscription.current.id
  role_definition_name = azurerm_role_definition.vault-role.name
  principal_id         = module.vault-vm[each.key].principal_id
}

locals {
  vm_keyvault_access_policies = {
    for k, v in var.vm_keyvault_access_policies : k => merge(v, { object_id = module.vault-vm[k].principal_id })
  }
  tf_access_policies = {
    current_object = {
      object_id               = data.azurerm_client_config.current.object_id
      key_permissions         = ["Create", "Delete", "GetRotationPolicy", "SetRotationPolicy", "Purge", "Get", "List"]
      secret_permissions      = ["Set", "Delete", "Purge", "Get", "List"]
      certificate_permissions = ["Get", "List"]
    }
  }
}