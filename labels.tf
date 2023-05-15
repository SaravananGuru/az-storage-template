module "tmp_labels" {
  source  = "github.com/SaravananGuru/az-label-terraform.git"
  name    = var.name
}

module "labels" {
  source                 = "github.com/SaravananGuru/az-label-terraform.git"
  name                   = var.name
  # storage_account_prefix = var.name_prefix

  tags = merge(
    {
      id = module.tmp_labels.id
    },
    var.tags
  )
}
