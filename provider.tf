provider "azurerm" {
  alias  = "y"
  subscription_id  = "4e094144-afbc-420a-8d74-a4a0da618a3b"
  tenant_id        = "b945c813-dce6-41f8-8457-5a12c2fe15bf"
  client_id        = var.on_premise_dns_client_id
  client_secret    = var.on_premise_dns_client_secret
  features {}
}