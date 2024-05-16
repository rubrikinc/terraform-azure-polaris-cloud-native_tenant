terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
    polaris = {
      source  = "rubrikinc/polaris"
      version = ">=0.9.0-beta.3"
    } 
  }
}

# # Configure the Azure Active Directory Provider
# provider "azuread" {
#   tenant_id = var.azure_tenant_id
# }

# # Point the provider to the RSC service account to use.
# provider "polaris" {
#   credentials = var.polaris_credentials
# } 