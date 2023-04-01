vault_cluster_name    = "hcpvault"
vault_version         = "1.13.0"
resource_group_name   = "rg-vault-eus"
kv_name               = "kv-vault-01-eus"
key_name              = "key-hashicorp-vault-master"
vnet_address_prefix   = "10.0.0.0/24"
vnet_name             = "vnet-vault-01-eus"
subnet_address_prefix = "10.0.0.0/27"
subnet_name           = "sn-vault-01-eus"
nsg_name              = "nsg-vault-01-eus"
sa_name               = "savaulteus01"
private_dns_zones     = ["privatelink.vaultcore.azure.net", "privatelink.blob.core.windows.net"]
vm_keyvault_access_policies = {
  azvaultvm01 = {
    key_permissions         = ["Get", "WrapKey", "UnwrapKey"]
    secret_permissions      = null
    certificate_permissions = null
  }
}
sa_containers = {
  vault = {
    access_type = "private"
  }
}
vault_vm_info = {
  azvaultvm01 = {
    size                            = "Standard_DS1_v2"
    disable_password_authentication = true
    identity_type                   = "SystemAssigned"
    os_disk_name                    = "OS"
    os_disk_type                    = "StandardSSD_LRS"
    os_disk_size_gb                 = 150
    source_image_reference = {
      image = {
        publisher = "RedHat"
        offer     = "RHEL"
        sku       = "86-gen2"
        version   = "latest"
      }
    }
    nic_config = {
      NIC01 = {
        name                          = "nic-vault-01"
        enable_accelerated_networking = true
        dns_servers                   = null
        private_ip_address            = null
        private_ip_address_allocation = "Dynamic"
      }
    }
  }
}
nsgrules = {
  Internet-Out = {
    priority                     = 210
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_port_ranges           = null
    destination_port_ranges      = null
    source_address_prefix        = "*"
    destination_address_prefix   = "Internet"
    source_address_prefixes      = null
    destination_address_prefixes = null
  }
}