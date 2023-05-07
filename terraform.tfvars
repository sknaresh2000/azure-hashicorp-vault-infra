vault_cluster_name     = "hcpvault"
vault_version          = "1.13.0"
resource_group_name    = "rg-vault-eus"
kv_name                = "kv-vault-01-eus"
key_name               = "key-hashicorp-vault-master"
vnet_address_prefix    = "10.0.0.0/24"
vnet_name              = "vnet-vault-01-eus"
sa_name                = "savaulteus01"
private_dns_zones      = ["privatelink.vaultcore.azure.net", "privatelink.blob.core.windows.net"]
bastion_name           = "bastion-vault-01-eus"
bastion_address_prefix = "10.0.0.0/27"
bastion_ip_config_name = "ipc-bastion-vault-01-eus"
bastion_pip_name       = "pip-bastion-vault-01-eus"
bastion_nsg_name       = "nsg-bastion-vault-01-eus"
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
subnets_info = {
  vault = {
    address_prefix = "10.0.0.32/27"
    name           = "sn-vault-01-eus"
    nsg_info = {
      name = "nsg-vault-01-eus"
      rules = {
        Internet-Out = {
          priority                     = 210
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "443"
          source_port_ranges           = null
          destination_port_ranges      = null
          source_address_prefix        = "10.0.0.32/27"
          destination_address_prefix   = "Internet"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
        Vault-Backend-Out = {
          priority                     = 220
          direction                    = "Outbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = "443"
          source_port_ranges           = null
          destination_port_ranges      = null
          source_address_prefix        = "10.0.0.32/27"
          destination_address_prefix   = "10.0.0.64/27"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
        Runner-In = {
          priority                     = 210
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = null
          source_port_ranges           = null
          destination_port_ranges      = ["443", "8200"]
          source_address_prefix        = "VirtualNetwork"
          destination_address_prefix   = "10.0.0.32/27"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
        AzureBastion-SSH-In = {
          priority                     = 220
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = null
          source_port_ranges           = null
          destination_port_ranges      = ["22"]
          source_address_prefix        = "10.0.0.0/27"
          destination_address_prefix   = "10.0.0.32/27"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
      }
    }
  }
  private-endpoint = {
    address_prefix = "10.0.0.64/27"
    name           = "sn-pe-01-eus"
    nsg_info = {
      name = "nsg-pe-01-eus"
      rules = {
        Vault-In = {
          priority                     = 210
          direction                    = "Inbound"
          access                       = "Allow"
          protocol                     = "Tcp"
          source_port_range            = "*"
          destination_port_range       = null
          source_port_ranges           = null
          destination_port_ranges      = ["443"]
          source_address_prefix        = "10.0.0.32/27"
          destination_address_prefix   = "10.0.0.64/27"
          source_address_prefixes      = null
          destination_address_prefixes = null
        }
      }
    }
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