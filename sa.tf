resource "azurerm_storage_account" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.storage_account_kind
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  access_tier               = contains(["BlobStorage", "FileStorage", "StorageV2"], var.storage_account_kind) ? var.storage_account_access_tier : null
  # default_action  = "Deny"
  enable_https_traffic_only = true
  min_tls_version           = var.min_tls_version
  is_hns_enabled            = var.storage_account_enable_hns
  tags                      = module.labels.tags

  # TODO
  # This is not supported yet as it is used for static_website mostly.
  # Alse we require https which would involve CDN setup to work.
  # custom_domain {}

  // identity {
  //   type = "SystemAssigned"
  // }

  dynamic "blob_properties" {
    for_each = length(var.cors_rules) == 0 && var.blob_retention_days == 0 ? [] : ["run once"]
    content {
      dynamic "cors_rule" {
        for_each = var.cors_rules
        content {
          allowed_headers    = cors_rule.value["allowed_headers"]
          allowed_methods    = cors_rule.value["allowed_methods"]
          allowed_origins    = cors_rule.value["allowed_origins"]
          exposed_headers    = cors_rule.value["exposed_headers"]
          max_age_in_seconds = cors_rule.value["max_age_in_seconds"]
        }
      }

      dynamic "delete_retention_policy" {
        for_each = var.blob_retention_days == 0 ? [] : ["run once"]
        content {
          days = var.blob_retention_days
        }
      }
    }
  }

  # TODO
  # queue_properties {}

  # TODO
  # This is not supported. There are no plans yet to host static websites with this.
  # static_website {}
}
