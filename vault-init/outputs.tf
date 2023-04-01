output "vault_customdata_base64_encoded" {
  value       = base64encode(local.vault_custom_data)
  description = "Base64 encoded Vault init script"
}

output "vault_customdata" {
  value       = local.vault_custom_data
  description = "Vault init script"
}