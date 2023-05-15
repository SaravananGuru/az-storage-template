locals {
  metadata_plain = { for k, v in module.labels.tags.id : lower(replace(k, "-", "_")) => v }
  metadata_b64   = { for k, v in local.metadata_plain : k => base64encode(v) }

  blob  = { for n, c in var.containers : n => c if try(c.type, "blob") == "blob" }
  adls2 = { for n, c in var.containers : n => c if try(c.type, "adls2") == "adls2" }
}

resource "azurerm_storage_container" "this" {
  for_each              = local.blob
  name                  = each.key
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = try(each.value.access_type, "private")
  metadata              = local.metadata_plain

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "this" {
  for_each           = local.adls2
  name               = each.key
  storage_account_id = azurerm_storage_account.this.id
  properties         = local.metadata_b64

  dynamic "ace" {
    for_each = length(var.adls2_root_principals) > 0 ? ["this"] : []
    content {
      type        = "user"
      scope       = "access"
      permissions = "rwx"
    }
  }

  dynamic "ace" {
    for_each = length(var.adls2_root_principals) > 0 ? ["this"] : []
    content {
      permissions = "r-x"
      scope       = "access"
      type        = "group"
    }
  }

  dynamic "ace" {
    for_each = length(var.adls2_root_principals) > 0 ? ["this"] : []
    content {
      permissions = "---"
      scope       = "access"
      type        = "other"
    }
  }

  dynamic "ace" {
    for_each = length(var.adls2_root_principals) > 0 ? ["this"] : []
    content {
      permissions = "r-x"
      scope       = "access"
      type        = "mask"
    }
  }

  dynamic "ace" {
    for_each = try(var.adls2_root_principals[each.key], [])
    content {
      type        = "user"
      id          = ace.value
      permissions = "--x"
    }
  }
}
