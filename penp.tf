module "penp_labels" {
  source  = "git::git@ssh.dev.azure.com:v3/fxe-data-mgmt/dmo-common-modules/terraform-null-label?ref=v1.0.1"
  context = module.labels.context
  names   = formatlist("%s-%s", var.name, keys(var.private_endpoints))
}

resource "azurerm_private_endpoint" "this" {
  for_each            = var.private_endpoints
  name                = module.penp_labels.ids_with_suffix[format("%s-%s", var.name, each.key)].pendp
  location            = azurerm_storage_account.this.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.subnet_id

  private_dns_zone_group {
    name                 = module.penp_labels.ids_with_suffix[format("%s-%s", var.name, each.key)].pendp
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  private_service_connection {
    name                           = module.penp_labels.ids_with_suffix[format("%s-%s", var.name, each.key)].pendp
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = [each.value.subresource_name]
    is_manual_connection           = each.value.is_manual_connection
  }

  tags = module.penp_labels.tags
}

locals {
  private_ips = { for k, v in azurerm_private_endpoint.this :
    k => v.private_service_connection[0].private_ip_address
  }
}