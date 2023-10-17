output "service_principal_object_id" {
  value = azuread_service_principal.polaris.object_id
}

output "service_principal_tenant_domain" {
  value = polaris_azure_service_principal.polaris.tenant_domain
}