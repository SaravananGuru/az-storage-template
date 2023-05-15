module "ds_labels" {
  source  = "git::git@ssh.dev.azure.com:v3/fxe-data-mgmt/dmo-common-modules/terraform-null-label?ref=v1.0.1"
  context = module.labels.context
  name    = join(module.labels.delimiter, compact([module.labels.name, "st"]))
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                   = var.log_analytics_workspace_id == "" ? {} : { this = "that" }
  name                       = module.ds_labels.id_with_suffix.ds
  target_resource_id         = azurerm_storage_account.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  # FIXME: parameter is not set.
  # log_analytics_destination_type = "Dedicated"

  /* None are available at the moment
  dynamic "log" {
    for_each = toset([])
    content {
      category = log.key
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.retain_log_in_days
      }
    }
  }
  */
  dynamic "metric" {
    for_each = toset(["Capacity", "Transaction"])
    content {
      category = metric.key
      enabled  = true

      retention_policy {
        enabled = true
        days    = var.retain_metrics_in_days
      }
    }
  }
}
