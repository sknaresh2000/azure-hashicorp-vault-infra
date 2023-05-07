## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.2.8 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | =2.36.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =3.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.36.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.47.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.2.1 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_AzureBastion"></a> [AzureBastion](#module\_AzureBastion) | git::https://github.com/sknaresh2000/terraform-azurerm-bastion.git | v0.0.1 |
| <a name="module_key-vault"></a> [key-vault](#module\_key-vault) | git::https://github.com/sknaresh2000/terraform-azurerm-key-vault.git | v0.0.1 |
| <a name="module_rg"></a> [rg](#module\_rg) | git::https://github.com/sknaresh2000/terraform-azurerm-resource-group.git | v0.0.1 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | git::https://github.com/sknaresh2000/terraform-azurerm-storage-account.git | v0.0.1 |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | git::https://github.com/sknaresh2000/terraform-azurerm-subnets.git | v0.0.1 |
| <a name="module_tags"></a> [tags](#module\_tags) | git::https://github.com/sknaresh2000/terraform-azurerm-tags.git | v0.0.1 |
| <a name="module_vault-init"></a> [vault-init](#module\_vault-init) | ./vault-init | n/a |
| <a name="module_vault-vm"></a> [vault-vm](#module\_vault-vm) | git::https://github.com/sknaresh2000/terraform-azurerm-linux-virtual-machine.git | v0.0.1 |
| <a name="module_virtual_network"></a> [virtual\_network](#module\_virtual\_network) | git::https://github.com/sknaresh2000/terraform-azurerm-virtual-network.git | v0.0.1 |

## Resources

| Name | Type |
|------|------|
| [azuread_directory_role.cloudapp-admin](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/resources/directory_role) | resource |
| [azuread_directory_role_assignment.vm_vault_role](https://registry.terraform.io/providers/hashicorp/azuread/2.36.0/docs/resources/directory_role_assignment) | resource |
| [azurerm_key_vault_access_policy.access_policies](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.vault-key](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.secret](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/key_vault_secret) | resource |
| [azurerm_private_dns_zone.dns](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet-link](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_role_assignment.sa_vault_role](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.vm_vault_role](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/role_assignment) | resource |
| [azurerm_role_definition.vault-role](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/resources/role_definition) | resource |
| [tls_private_key.tls](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.47.0/docs/data-sources/subscription) | data source |
| [http_http.ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Name of the application that will be deployed | `string` | `"HashiCorp-Vault"` | no |
| <a name="input_bastion_address_prefix"></a> [bastion\_address\_prefix](#input\_bastion\_address\_prefix) | The address prefix of the Bastion subnet that will be created for Vault | `string` | n/a | yes |
| <a name="input_bastion_ip_config_name"></a> [bastion\_ip\_config\_name](#input\_bastion\_ip\_config\_name) | Azure Bastion IP Config name | `string` | n/a | yes |
| <a name="input_bastion_name"></a> [bastion\_name](#input\_bastion\_name) | The name of Azure Bastion | `string` | n/a | yes |
| <a name="input_bastion_nsg_name"></a> [bastion\_nsg\_name](#input\_bastion\_nsg\_name) | The name of the NSG that will be created for Azure Bastion | `string` | n/a | yes |
| <a name="input_bastion_pip_name"></a> [bastion\_pip\_name](#input\_bastion\_pip\_name) | Public ip name to be used for Azure Bastion | `string` | n/a | yes |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | Name of the key that will be used for vault auto unseal | `string` | n/a | yes |
| <a name="input_kv_name"></a> [kv\_name](#input\_kv\_name) | Name of the Key vault that will contain VM and Vault keys/certificates | `string` | n/a | yes |
| <a name="input_private_dns_zones"></a> [private\_dns\_zones](#input\_private\_dns\_zones) | List of private dns zones that needs to be created for vault backend and keys in Azure. | `list(string)` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group that will be used to create Vault and its infrastructure | `string` | n/a | yes |
| <a name="input_sa_containers"></a> [sa\_containers](#input\_sa\_containers) | Details of the containers that needs to be created in the storage account for Vault | <pre>map(object({<br>    access_type = string<br>  }))</pre> | n/a | yes |
| <a name="input_sa_name"></a> [sa\_name](#input\_sa\_name) | The name of the storage account name for Vault backend | `string` | n/a | yes |
| <a name="input_subnets_info"></a> [subnets\_info](#input\_subnets\_info) | Details of the subnets and its associated NSG that will be created for vault | <pre>map(object({<br>    address_prefix = string<br>    name           = string<br>    nsg_info = object({<br>      name = string<br>      rules = map(object({<br>        priority                     = number<br>        direction                    = string<br>        access                       = string<br>        protocol                     = string<br>        source_port_range            = string<br>        destination_port_range       = string<br>        source_port_ranges           = list(string)<br>        destination_port_ranges      = list(string)<br>        source_address_prefix        = string<br>        destination_address_prefix   = string<br>        source_address_prefixes      = list(string)<br>        destination_address_prefixes = list(string)<br>      }))<br>    })<br>  }))</pre> | n/a | yes |
| <a name="input_vault_cluster_name"></a> [vault\_cluster\_name](#input\_vault\_cluster\_name) | Name of the Vault cluster | `string` | n/a | yes |
| <a name="input_vault_version"></a> [vault\_version](#input\_vault\_version) | Version of the vault to be deployed | `string` | n/a | yes |
| <a name="input_vault_vm_info"></a> [vault\_vm\_info](#input\_vault\_vm\_info) | Details of the vault VM that will be provisioned | `any` | n/a | yes |
| <a name="input_vm_keyvault_access_policies"></a> [vm\_keyvault\_access\_policies](#input\_vm\_keyvault\_access\_policies) | value | <pre>map(object({<br>    key_permissions         = list(string)<br>    secret_permissions      = list(string)<br>    certificate_permissions = list(string)<br>  }))</pre> | n/a | yes |
| <a name="input_vnet_address_prefix"></a> [vnet\_address\_prefix](#input\_vnet\_address\_prefix) | The address prefix that will be used for the creation of VNET | `string` | n/a | yes |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | Name of the VNET that will be created for Hashicorp Vault | `string` | n/a | yes |

## Outputs

No outputs.
