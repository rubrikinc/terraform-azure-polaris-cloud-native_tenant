output "azure_service_principal_object_id" {
  description = "The Azure object id of the service principal used by RSC."
  value       = azuread_service_principal.polaris.object_id
}

output "rsc_service_principal_tenant_domain" {
  description = "The Azure domain name of the service principal used by RSC."
  value       = polaris_azure_service_principal.polaris.tenant_domain
}
