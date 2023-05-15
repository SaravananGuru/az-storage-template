locals {
  default_rule_actions = {
    for k, v in var.default_lifecycle_actions : k => v if k == "base_blob" || k == "snapshot"
  }
  default_policy = length(local.default_rule_actions) == 0 ? [] : ["default"]
}
resource "azurerm_storage_management_policy" "default" {
  for_each           = toset(local.default_policy)
  storage_account_id = azurerm_storage_account.this.id

  rule {
    name    = "default"
    enabled = true
    filters {
      blob_types = [
        "blockBlob",
      ]
      prefix_match = []
    }
    actions {
      dynamic "base_blob" {
        for_each = can(local.default_rule_actions.base_blob) ? [local.default_rule_actions.base_blob] : []
        content {
          tier_to_cool_after_days_since_modification_greater_than    = try(base_blob.value.tier_to_cool_after_days_since_modification_greater_than, 0)
          tier_to_archive_after_days_since_modification_greater_than = try(base_blob.value.tier_to_archive_after_days_since_modification_greater_than, 0)
          delete_after_days_since_modification_greater_than          = try(base_blob.value.delete_after_days_since_modification_greater_than, 0)
        }
      }
      dynamic "snapshot" {
        for_each = can(local.default_rule_actions.snapshot) ? [local.default_rule_actions.snapshot] : []
        content {
          delete_after_days_since_creation_greater_than = try(snapshot.value.delete_after_days_since_creation_greater_than, null)
        }
      }
    }
  }
}
