# Get RSC Account details.
data "polaris_account" "polaris" {}

# Get current user information.
data "azuread_client_config" "current" {}

# Retrieve Entra ID domain information.
data "azuread_domains" "polaris" {
  only_initial = true
}

# Retrieve Entra ID well-known app info.
data "azuread_application_published_app_ids" "well_known" {}

# MSGraph.
data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result["MicrosoftGraph"]
}

# Azure Storage.
data "azuread_service_principal" "azstg" {
  client_id = data.azuread_application_published_app_ids.well_known.result["AzureStorage"]
}

# Azure Service Management.
data "azuread_service_principal" "azsvcmgmt" {
  client_id = data.azuread_application_published_app_ids.well_known.result["AzureServiceManagement"]
}

# Create an application.
resource "azuread_application" "polaris" {
  display_name            = var.azure_application_display_name
  owners                  = [data.azuread_client_config.current.object_id]
  prevent_duplicate_names = true

  web {
    homepage_url = "https://${data.polaris_account.polaris.fqdn}/setup_azure"
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph

    resource_access {
      id   = data.azuread_service_principal.msgraph.oauth2_permission_scope_ids["User.Read"]
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.AzureStorage

    resource_access {
      id   = data.azuread_service_principal.azstg.oauth2_permission_scope_ids["user_impersonation"]
      type = "Scope"
    }
  }

  required_resource_access {
    resource_app_id = data.azuread_application_published_app_ids.well_known.result.AzureServiceManagement

    resource_access {
      id   = data.azuread_service_principal.azsvcmgmt.oauth2_permission_scope_ids["user_impersonation"]
      type = "Scope"
    }
  }
}

# Create a service principal.
resource "azuread_service_principal" "polaris" {
  client_id = azuread_application.polaris.client_id
  owners    = [data.azuread_client_config.current.object_id]

  # If app_role_assignment_required value is set to true, then it is required a user or group is assigned in order to use this app.
  # This is recommended to ensure only authorized users are able to operate Rubrik Security Cloud through this App.
  app_role_assignment_required = true

  # If set to true, then see the azuread_group data import and azuread_app_role_assignment resource examples below.
  # Modify to align to your requirements for the same.
  feature_tags {
    hide = "true"
  }
}

# MS Graph API User.Read delegated permission grant.
resource "azuread_service_principal_delegated_permission_grant" "msgraph" {
  service_principal_object_id          = azuread_service_principal.polaris.object_id
  resource_service_principal_object_id = data.azuread_service_principal.msgraph.object_id
  claim_values                         = ["User.Read"]
}

# Azure Storage API user_impersonation delegated permission grant.
resource "azuread_service_principal_delegated_permission_grant" "azstg" {
  service_principal_object_id          = azuread_service_principal.polaris.object_id
  resource_service_principal_object_id = data.azuread_service_principal.azstg.object_id
  claim_values                         = ["user_impersonation"]
}

# Azure Service Management API user_impersonation delegated permission grant.
resource "azuread_service_principal_delegated_permission_grant" "azsvcmgmt" {
  service_principal_object_id          = azuread_service_principal.polaris.object_id
  resource_service_principal_object_id = data.azuread_service_principal.azsvcmgmt.object_id
  claim_values                         = ["user_impersonation"]
}

# Import the group used for all users of Rubrik Security Cloud.
# May be created in this module, or externally as shown in the example below.
data "azuread_group" "rsc" {
  display_name     = "RSC Users"
  security_enabled = true
}

# Assign the RSC Users group to the app.
resource "azuread_app_role_assignment" "polaris" {
  app_role_id         = "00000000-0000-0000-0000-000000000000" # https://learn.microsoft.com/en-us/graph/api/resources/approleassignment?view=graph-rest-1.0#properties
  principal_object_id = data.azuread_group.rsc.object_id
  resource_object_id  = azuread_service_principal.polaris.object_id
}

# Create a password for the application.
resource "azuread_application_password" "polaris" {
  application_id = azuread_application.polaris.id
}

# Add the service principal to RSC.
resource "polaris_azure_service_principal" "polaris" {
  app_id        = azuread_application.polaris.client_id
  app_name      = azuread_service_principal.polaris.display_name
  app_secret    = azuread_application_password.polaris.value
  tenant_domain = data.azuread_domains.polaris.domains.0.domain_name
  tenant_id     = azuread_service_principal.polaris.application_tenant_id
}
