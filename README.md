# Terraform Module - Azure Rubrik Cloud Native Tenant
This module adds an Azure tenant to the Rubrik Security Cloud (RSC/Polaris).

## Usage
```hcl
module "polaris_azure_cloud_native_tenant" {
  source = "rubrikinc/polaris-cloud-native_tenant/azure"
}
```

## Examples
- [Basic Tenant](https://github.com/rubrikinc/terraform-azure-polaris-cloud-native_tenant/tree/master/examples/basic)

## Changelog

### v1.1.2
* Update the version constraint of `rubrikinc/polaris` provider to `>=1.1.0`.

### v1.1.1
* Initialize the `app_name` of the `polaris_azure_service_principal` resource using the `display_name` of the
  `azuread_application` instead of the `azuread_service_principal`.

### v1.1.0
* Replace the `azuread_service_principal_password` resource with the `azuread_application_password` resource. This will
  update the secret of the `polaris_azure_service_principal` resource.
* Add `azure_application_display_name` as an input variable.
* Mark `azure_tenant_id` and `polaris_credentials` input variables as deprecated. They are no longer used by the module
  and have no replacements.
* Move example configuration code from the README.md file to the examples directory.

## Upgrading

### v1.0.1 to v1.1.x
1. Change the version of the module from `1.0.1` to `1.1.1`. Depending on your configuration, you might need to update
   the version of the [Cloud Native Tenant](https://registry.terraform.io/modules/rubrikinc/polaris-cloud-native_tenant/azure/latest)
   module to version `2.1.0` for Terraform to be able to find a suitable version of the RSC (polaris) Terraform
   provider.
2. Run `terraform init -upgrade`. The `-upgrade` command line option is required since the updated module requires a new
   version of the RSC (polaris) Terraform provider.
3. Run `terraform plan`, this should result in an `Provider configuration not present` error. The resource
   `module.azure_tenant.azuread_service_principal_password.polaris` should be orphaned. This is because the
   `azuread_service_principal_password` resource has been replaced with an `azuread_application_password` resource.
4. Run `terraform state rm module.azure_tenant.azuread_service_principal_password.polaris` to remove the orphaned
   resource.
5. Run `terraform plan` and check the output carefully, there should only be resources added or updated in place. There
   should be no resources replaced or removed.
6. Run `terraform apply`.

Additional notes, the `azuread_application` resource haven been changed to require the `display_name` to be unique. If
this causes any issue, you can change the display name using the new `azure_application_display_name` variable.

## Troubleshooting

### Error: failed to lookup principal
```
╷
│ Error: failed to lookup principal: failed to lookup app display name and object id for service principal: failed to get Azure service principal names using Graph: graphrbac.ServicePrincipalsClient#List: Failure responding to request: StatusCode=401 -- Original Error: autorest/azure: Service returned an error. Status=401 Code="Unknown" Message="Unknown service error" Details=[{"odata.error":{"code":"Authorization_IdentityNotFound","date":"2023-10-02T18:43:00","message":{"lang":"en","value":"The identity of the calling application could not be established."},"requestId":"3df53cfb-0f10-494d-84a9-da86d4348353"}}]
│ 
│   with polaris_azure_service_principal.polaris,
│   on main.tf line 22, in resource "polaris_azure_service_principal" "polaris":
│   22: resource "polaris_azure_service_principal" "polaris" {
╵
```
Solution: Use the Azure CLI tools to log out and back in again.
```
az logout
az login --tenant <tenant-id>
```

### Error: failed to add subscription
When the last subscription in an Azure tenant has been remove from RSC you may get this error, as the tenant has also
been removed from RSC:
```
╷
│ Error: failed to add subscription: failed to request addAzureCloudAccountWithoutOauth: graphql response body is an error (status code 200): NOT_FOUND: Failed to get service principal in the tenant. Azure may take some time to sync service principal. Please try after a minute (Azure error: [Unknown] Unknown service error) (code: 404, traceId: FWaZk7YsxjaRDF5NlWWsAw==)
│ 
│   with polaris_azure_subscription.polaris,
│   on main.tf line 84, in resource "polaris_azure_subscription" "polaris":
│   84: resource "polaris_azure_subscription" "polaris" { 
╵
```
Solution: Taint the `polaris_azure_service_principal.polaris` resource and re-run the apply operation.

## How You Can Help
We welcome contributions from the community. From updating the documentation to adding more functionality, all ideas are
welcome. Thank you in advance for all of your issues, pull requests, and comments!
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Contributing Guide](CONTRIBUTING.md)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.15.0 |
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | >=1.1.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >=0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 3.5.0   |
| <a name="provider_polaris"></a> [polaris](#provider\_polaris) | 1.1.6   |
| <a name="provider_time"></a> [time](#provider\_time) | 0.13.1  |

## Resources

| Name | Type |
|------|------|
| [azuread_app_role_assignment.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/app_role_assignment) | resource |
| [azuread_application.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_application_password.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_password) | resource |
| [azuread_service_principal.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_delegated_permission_grant.azstg](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) | resource |
| [azuread_service_principal_delegated_permission_grant.azsvcmgmt](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) | resource |
| [azuread_service_principal_delegated_permission_grant.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_delegated_permission_grant) | resource |
| [polaris_azure_service_principal.polaris](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/resources/azure_service_principal) | resource |
| [time_sleep.wait_for_sp](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_application_published_app_ids.well_known](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application_published_app_ids) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_domains.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [azuread_group.rsc](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) | data source |
| [azuread_service_principal.azstg](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.azsvcmgmt](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [azuread_service_principal.msgraph](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) | data source |
| [polaris_account.polaris](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/data-sources/account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_application_display_name"></a> [azure\_application\_display\_name](#input\_azure\_application\_display\_name) | Display name for the Azure application. | `string` | `"Rubrik Security Cloud - Azure Protection"` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Deprecated: no replacement. | `string` | `null` | no |
| <a name="input_polaris_credentials"></a> [polaris\_credentials](#input\_polaris\_credentials) | Deprecated: no replacement. | `string` | `null` | no |
| <a name="input_rsc_sync_delay"></a> [rsc\_sync\_delay](#input\_rsc\_sync\_delay) | Delay so that Azure and RSC can sync on the new service principal. | `string` | `"60s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_service_principal_object_id"></a> [azure\_service\_principal\_object\_id](#output\_azure\_service\_principal\_object\_id) | The Azure object id of the service principal used by RSC. |
| <a name="output_rsc_service_principal_tenant_domain"></a> [rsc\_service\_principal\_tenant\_domain](#output\_rsc\_service\_principal\_tenant\_domain) | The Azure domain name of the service principal used by RSC. |
<!-- END_TF_DOCS -->
