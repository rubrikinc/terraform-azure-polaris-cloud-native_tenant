variable "azure_application_display_name" {
  type        = string
  description = "Display name for the Azure application."
  default     = "Rubrik Security Cloud - Azure Protection"
}

variable "azure_tenant_id" {
  type        = string
  description = "Deprecated: no replacement."
  default     = null
}

variable "polaris_credentials" {
  type        = string
  description = "Deprecated: no replacement."
  default     = null
}

variable "rsc_sync_delay" {
  type        = string
  description = "Deprecated: no replacement."
  default     = null
}

check "deprecations" {
  assert {
    condition     = var.azure_tenant_id == null
    error_message = "The azure_tenant_id variable has been deprecated. It has no replacement and will be removed in a future release."
  }
  assert {
    condition     = var.polaris_credentials == null
    error_message = "The polaris_credentials variable has been deprecated. It has no replacement and will be removed in a future release."
  }
  assert {
    condition     = var.rsc_sync_delay == null
    error_message = "The rsc_sync_delay variable has been deprecated. It has no replacement and will be removed in a future release."
  }
}
