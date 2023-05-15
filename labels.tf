module "tmp_labels" {
  source  = "git::git@ssh.dev.azure.com:v3/fxe-data-mgmt/dmo-common-modules/terraform-null-label?ref=v1.0.1"
  context = var.labels_context
  name    = var.name
}

module "labels" {
  source                 = "git::git@ssh.dev.azure.com:v3/fxe-data-mgmt/dmo-common-modules/terraform-null-label?ref=v1.0.1"
  context                = module.tmp_labels.context
  name                   = var.name
  storage_account_prefix = var.name_prefix

  tags = merge(
    {
      id = module.tmp_labels.id
    },
    var.tags
  )
}
