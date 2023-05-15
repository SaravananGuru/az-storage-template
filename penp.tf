module "penp_labels" {
  source  = "github.com/SaravananGuru/az-label-terraform.git"
  name   = format("%s-%s", var.name, "pep")
}

resource "azurerm_private_endpoint" "this" {
  for_each            = var.private_endpoints
  name                = module.penp_labels.name
  location            = azurerm_storage_account.this.location
  resource_group_name = var.resource_group_name
  subnet_id           = each.value.subnet_id

  private_dns_zone_group {
    name                 = module.penp_labels.id[format("%s-%s", var.name, each.key)].pendp
    private_dns_zone_ids = [each.value.private_dns_zone_id]
  }

  private_service_connection {
    name                           = module.penp_labels.id[format("%s-%s", var.name, each.key)].pendp
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