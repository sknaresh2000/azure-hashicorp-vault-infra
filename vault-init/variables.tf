variable "vault_version" {
  type        = string
  description = "Version of vault that will be deployed"
}

variable "sa_account_name" {
  type        = string
  description = "The name of the storage account for the vault backend"
}

variable "sa_container_name" {
  type        = string
  description = "The name of the storage account container for the vault backend"
}

variable "tenant_id" {
  type        = string
  description = "The tenant id where the vault will be deployed"
}

variable "kv_name" {
  type        = string
  description = "The key vault that will be used for vault unseal"
}

variable "kv_key_name" {
  type        = string
  description = "The key that will be used for the vault unseal"
}

variable "cluster_name" {
  type        = string
  description = "The name of the vault cluster"
}