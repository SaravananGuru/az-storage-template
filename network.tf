resource "azurerm_storage_account_network_rules" "this" {
  # Only one of these needs to be cretaed if `virtual_network_subnet_ids` is defined
  count               = min(length(var.virtual_network_subnet_ids), 1)
  # resource_group_name = var.resource_group_name
  # storage_account_name = azurerm_storage_account.this.name
  storage_account_id         = azurerm_storage_account.this.id
  default_action             = "Deny"
  virtual_network_subnet_ids = var.virtual_network_subnet_ids
  bypass                     = compact(toset(concat(var.network_bypass, ["AzureServices"])))
}
