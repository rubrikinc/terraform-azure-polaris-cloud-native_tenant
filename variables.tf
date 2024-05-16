variable "azure_tenant_id" {
  type = string
  description = "ID of Azure Tenant to protect."
} 

variable "polaris_credentials" {
  type        = string
  description = "Full path to credentials file for RSC/Polaris."
}
variable "rsc_sync_delay" {
  type        = string
  description = "Delay so that Azure and RSC can sync on the new service principal."
  default     = "60s"  
}