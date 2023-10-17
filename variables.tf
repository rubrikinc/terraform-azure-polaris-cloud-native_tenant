variable "azure_tenant_id" {
  type = string
  description = "ID of Azure Tenant to protect."
} 

variable "polaris_credentials" {
  type        = string
  description = "Full path to credentials file for RSC/Polaris."
}

variable "polaris_fqdn" {
  type        = string
  description = "The fully qualified domain name (FQDN) portion of the RSC/Polaris URL for this tenant."
}