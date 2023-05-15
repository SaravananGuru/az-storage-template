variable "name" {
  description = "This module name. It will be used to form resource names with name parameter to labels module."
  type        = string
  default     = "storage"
}

variable "name_prefix" {
  description = "String to prefix storage account name with: <prefix>sha256(id) cut to 24  char length"
  type        = string
  default     = "st"
}

variable "tags" {
  description = "Additional tags to put on all resources of this module, this will be added to labels tags"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Name of the resource group to use, or empty string to create a new one."
  type        = string
}

# Storage account params

variable "storage_account_kind" {
  description = "https://www.terraform.io/docs/providers/azurerm/r/storage_account.html#account_kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_tier" {
  description = "Storage account tier: Standard or Premium."
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "Type of replication to use for this storage account. LRS, GRS, RAGRS or ZRS."
  type        = string
  default     = "LRS"
}

variable "storage_account_access_tier" {
  description = "Access tier for BlobStorage, FileStorage and StorageV2"
  type        = string
  default     = "Hot"
}

variable "allow_blob_public_access" {
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  type        = bool
  default     = false
}

variable "cors_rules" {
  description = "Allow or disallow public access to all blobs or containers in the storage account."
  type = list(
    object({
      allowed_headers    = list(string),
      allowed_methods    = list(string),
      allowed_origins    = list(string),
      exposed_headers    = list(string),
      max_age_in_seconds = number
    })
  )
  default = []
}

variable "min_tls_version" {
  description = "Minimum TLS version required to connect"
  type        = string
  default     = "TLS1_2"
}

variable "storage_account_enable_hns" {
  description = "Enable hierarchical namespace for Azure Data Lake Storage Gen 2"
  type        = bool
  default     = true
}

variable "blob_retention_days" {
  description = "Number of days that the blob should be retained, between 1 and 365. Default is 0 - do not configure."
  type        = number
  default     = 0
}

# Endpoints

variable "private_endpoints" {
  description = "Create private endpoint for this storage account."
  type = map(object({
    subnet_id            = string
    subresource_name     = string
    private_dns_zone_id  = string
    on_prem_zone_name    = string
    on_prem_rg           = string
    is_manual_connection = bool
    allow_on_prem_access = bool

  }))
  default = {}
}

# containers

variable "containers" {
  description = "Map of the containers to create. {<name> = { type = `blob|adls2`, access_type = `private`}"
  type        = map(map(any))
  default     = {}
}

variable "default_lifecycle_actions" {
  description = "Actions of the lifecycle rule that will be applied to all containers (no filters)"
  type        = map(map(string))
  default     = {}
}

# monitoring

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace where Diagnostics Data should be sent."
  type        = string
  default     = ""
}

variable "retain_log_in_days" {
  description = "Retain logs for this much days."
  type        = number
  default     = 15
}

variable "retain_metrics_in_days" {
  description = "Retain logs for this much days."
  type        = number
  default     = 15
}

# network rules

variable "virtual_network_subnet_ids" {
  description = "Subnet Id's which are allowed to access this storage account."
  type        = list(string)
  default     = []
}

variable "network_bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics (AzureServices is always added). Valid options are any combination of Logging, Metrics or None."
  type        = list(string)
  default     = []
}

variable "adls2_root_principals" {
  description = "If you are planninc to user ACLs, all principals must have certain permissions set on the root level, include those principals here"
  type        = map(list(string))
  default     = {}
}
