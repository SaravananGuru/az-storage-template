output "id" {
  description = "Storage account ID"
  value       = azurerm_storage_account.this.id
}

output "name" {
  description = "Storage account name"
  value       = azurerm_storage_account.this.name
}

output "storage_account_identity" {
  description = "Storage account managed identity principal_id and tenant_id"
  value       = azurerm_storage_account.this.identity
}

output "private_ips" {
  description = "Name to private IP map of the private endpoints."
  value       = local.private_ips
}

output "blob_containers" {
  description = "Blob containers created by this module"
  value       = azurerm_storage_container.this
}

output "adls2_containers" {
  description = "ADLS2 containers created by this module"
  value       = azurerm_storage_data_lake_gen2_filesystem.this
}

output "storage_account" {
  description = "Storage account object that was created by the module"
  value       = azurerm_storage_account.this
  sensitive   = true
}

output "labels" {
  description = "The internal labels context"
  value       = module.labels
}
