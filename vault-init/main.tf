locals {
  vault_custom_data = templatefile("${path.module}/custom_data_script.sh.tpl",
    {
      vault_version        = var.vault_version
      vault_service_config = file("./${path.module}/vault.service")
      vault_config         = file("${path.module}/vault.config")
      sa_account_name      = var.sa_account_name
      sa_container_name    = var.sa_container_name
      cluster_name         = var.cluster_name
      tenant_id            = var.tenant_id
      kv_name              = var.kv_name
      kv_key_name          = var.kv_key_name
  })
}