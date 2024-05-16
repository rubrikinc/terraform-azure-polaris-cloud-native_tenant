# Get RSC Account details
data "polaris_account" "polaris" {}

# get current user information
data "azuread_client_config" "current" {}


# Retrieve domain information
data "azuread_domains" "polaris" {
  only_initial = true
}

# Create an application
resource "azuread_application" "polaris" {
  display_name = "Rubrik Cloud Integration - terraform"
  owners       = [data.azuread_client_config.current.object_id]
  web {
    homepage_url  = "https://${data.polaris_account.polaris.fqdn}/setup_azure"
  }
}

# Create a service principal
resource "azuread_service_principal" "polaris" {
  client_id = azuread_application.polaris.client_id
  owners  = [data.azuread_client_config.current.object_id]
}

# Create a password for the service principal 
resource "azuread_service_principal_password" "polaris" {
  service_principal_id = azuread_service_principal.polaris.object_id
}

# Add the service principal to RSC:
resource "polaris_azure_service_principal" "polaris" {
  app_id        = azuread_application.polaris.client_id
  app_name      = azuread_service_principal.polaris.display_name
  app_secret    = azuread_service_principal_password.polaris.value
  tenant_domain = data.azuread_domains.polaris.domains.0.domain_name
  tenant_id     = azuread_service_principal.polaris.application_tenant_id
} 

# Give RSC and   service principal to be created before adding the subscription.
resource time_sleep "wait_for_sp" {
  depends_on      = [polaris_azure_service_principal.polaris]
  create_duration = var.rsc_sync_delay
}