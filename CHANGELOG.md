# Changelog

## v2.1.0
* Replaced the `azuread_service_principal_password` resource with the `azuread_application_password resource`. This will
  update the secret of the `polaris_azure_service_principal` resource.
* Added `azure_application_display_name` as a module input variable.
* Deprecated the `azure_tenant_id` module input variable. The variable is no longer used in the module.
* Deprecated the `polaris_credentials` module input variable. The variable is no longer used in the module.
* Deprecated the `rsc_sync_delay` module input variable. The variable is no longer used in the module.
