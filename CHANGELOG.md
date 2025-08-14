# Changelog

## v1.1.2
* Update the version constraint of `rubrikinc/polaris` provider to `>=1.1.0`.

## v1.1.1
* Initialize the `app_name` of the `polaris_azure_service_principal` resource using the `display_name` of the
  `azuread_application` instead of the `azuread_service_principal`.

## v1.1.0
* Replace the `azuread_service_principal_password` resource with the `azuread_application_password` resource. This will
  update the secret of the `polaris_azure_service_principal` resource.
* Add `azure_application_display_name` as an input variable.
* Mark `azure_tenant_id` and `polaris_credentials` input variables as deprecated. They are no longer used by the module
  and have no replacements.
* Move example configuration code from the README.md file to the examples directory.
