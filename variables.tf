variable "vault_cluster_name" {
  type        = string
  description = "Name of the Vault cluster"
}

variable "vault_version" {
  type        = string
  description = "Version of the vault to be deployed"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group that will be used to create Vault and its infrastructure"
}

variable "app_name" {
  type        = string
  description = "Name of the application that will be deployed"
  default     = "HashiCorp-Vault"
}

variable "kv_name" {
  type        = string
  description = "Name of the Key vault that will contain VM and Vault keys/certificates"
}

variable "key_name" {
  type        = string
  description = "Name of the key that will be used for vault auto unseal"
}

variable "vnet_address_prefix" {
  type        = string
  description = "The address prefix that will be used for the creation of VNET"
}

variable "vnet_name" {
  type        = string
  description = "Name of the VNET that will be created for Hashicorp Vault"
}

variable "bastion_address_prefix" {
  type        = string
  description = "The address prefix of the Bastion subnet that will be created for Vault"
}

variable "bastion_name" {
  type        = string
  description = "The name of Azure Bastion"
}

variable "bastion_nsg_name" {
  type        = string
  description = "The name of the NSG that will be created for Azure Bastion"
}

variable "sa_name" {
  type        = string
  description = "The name of the storage account name for Vault backend"
}

variable "sa_containers" {
  type = map(object({
    access_type = string
  }))
  description = "Details of the containers that needs to be created in the storage account for Vault"
}

variable "vm_keyvault_access_policies" {
  type = map(object({
    key_permissions         = list(string)
    secret_permissions      = list(string)
    certificate_permissions = list(string)
  }))
  description = "value"
}

variable "vault_vm_info" {
  description = "Details of the vault VM that will be provisioned"
}

variable "private_dns_zones" {
  type        = list(string)
  description = "List of private dns zones that needs to be created for vault backend and keys in Azure."
}

variable "bastion_ip_config_name" {
  type        = string
  description = "Azure Bastion IP Config name"
}

variable "bastion_pip_name" {
  type        = string
  description = "Public ip name to be used for Azure Bastion"
}

variable "subnets_info" {
  type = map(object({
    address_prefix = string
    name           = string
    nsg_info = object({
      name = string
      rules = map(object({
        priority                     = number
        direction                    = string
        access                       = string
        protocol                     = string
        source_port_range            = string
        destination_port_range       = string
        source_port_ranges           = list(string)
        destination_port_ranges      = list(string)
        source_address_prefix        = string
        destination_address_prefix   = string
        source_address_prefixes      = list(string)
        destination_address_prefixes = list(string)
      }))
    })
  }))
  description = "Details of the subnets and its associated NSG that will be created for vault"
}