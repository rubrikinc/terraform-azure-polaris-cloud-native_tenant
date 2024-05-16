# Terraform Module - Azure Rubrik Cloud Native Tenant

This module adds an Azure tenant to Rubrik Security Cloud (RSC/Polaris). It is designed to be work with the [Terraform Module - Azure Rubrik Cloud Native Subscription](https://github.com/rubrikinc/terraform-azure-polaris-cloud-native_subscription) module.

## Prerequisites

There are a few services you'll need in order to get this project off the ground:

- [Terraform](https://www.terraform.io/downloads.html) v1.5.1 or greater
- [Rubrik Polaris Provider for Terraform](https://github.com/rubrikinc/terraform-provider-polaris) - provides Terraform functions for Rubrik Security Cloud (Polaris)
- [Install the Azure CLI tools](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) - Needed for Terraform to authenticate with Azure
- Properly configure the backend for this module. See [Configure the Backend](#configure-the-backend) in this [README.md](README.md).

## Usage

```hcl

terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
    }
    polaris = {
      source  = "rubrikinc/polaris"
      version = "0.9.0-beta.3"
    } 
  }
}

# Configure the Azure Active Directory Provider
provider "azuread" {
  tenant_id = var.azure_tenant_id
}

# Point the provider to the RSC service account to use.
provider "polaris" {
  credentials = var.polaris_credentials
} 

module "polaris-azure-cloud-native_tenant" {
  source                          = "rubrikinc/polaris-cloud-native_tenant/azure"
  
  azure_tenant_id                 = "abcdef01-2345-6789-abcd-ef0123456789"
  polaris_credentials             = "../.creds/customer-service-account.json"
}
```

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | >=0.9.0-beta.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | n/a |
| <a name="provider_polaris"></a> [polaris](#provider\_polaris) | >=0.9.0-beta.3 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Resources

| Name | Type |
|------|------|
| [azuread_application.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) | resource |
| [azuread_service_principal.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) | resource |
| [azuread_service_principal_password.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_password) | resource |
| [polaris_azure_service_principal.polaris](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/resources/azure_service_principal) | resource |
| [time_sleep.wait_for_sp](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azuread_domains.polaris](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/domains) | data source |
| [polaris_account.polaris](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/data-sources/account) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | ID of Azure Tenant to protect. | `string` | n/a | yes |
| <a name="input_polaris_credentials"></a> [polaris\_credentials](#input\_polaris\_credentials) | Full path to credentials file for RSC/Polaris. | `string` | n/a | yes |
| <a name="input_rsc_sync_delay"></a> [rsc\_sync\_delay](#input\_rsc\_sync\_delay) | Delay so that Azure and RSC can sync on the new service principal. | `string` | `"60s"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azure_service_principal_object_id"></a> [azure\_service\_principal\_object\_id](#output\_azure\_service\_principal\_object\_id) | n/a |
| <a name="output_rsc_service_principal_tenant_domain"></a> [rsc\_service\_principal\_tenant\_domain](#output\_rsc\_service\_principal\_tenant\_domain) | n/a |


<!-- END_TF_DOCS -->

### Login to Azure

Before running Terraform using the `azurerm_*` or `azapi_*` data sources and resources, an authentication with Azure is required. [Terraform Module for AzureRM CLI Authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/azure_cli)
provides a complete guide on how to authenticate Terraform with Azure. The following commands can be used from a command line interface with the [Microsoft Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
to manually run Terraform:

`az login --tenant <tenant_id>`

Where <tenant_id> is the ID of the tenant to login to. If you only have one tenant you can remove the `--tenant` option.

Next before running this module, the subscription must be selected. Do this by running the command:

`az account set --subscription <subscription_id>`

Where <subscription_id> is the ID of the subscription where CCES will be deployed.

## Initialize the Directory

The directory can be initialized for Terraform use by running the `terraform init` command:

```none
-> terraform init         

Initializing the backend...

Successfully configured the backend "local"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding latest version of hashicorp/azuread...
- Finding latest version of rubrikinc/polaris...
- Installing hashicorp/azuread v2.43.0...
- Installed hashicorp/azuread v2.43.0 (signed by HashiCorp)
- Installing rubrikinc/polaris v0.7.2...
- Installed rubrikinc/polaris v0.7.2 (signed by a HashiCorp partner, key ID 6B41B7EAD9DB76FB)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
## Planning

Run `terraform plan` to get information about what will happen when we apply the configuration; this will test that everything is set up correctly.

## Applying

We can now apply the configuration to add the Azure tenant to RSC using the `terraform apply` command.

## Destroying

Once the subscription no longer needs protection, it can be removed from RSC using the `terraform destroy` command, and entering `yes` when prompted.

## Troubleshooting

### Error: failed to lookup principal

```
│ Error: failed to lookup principal: failed to lookup app display name and object id for service principal: failed to get Azure service principal names using Graph: graphrbac.ServicePrincipalsClient#List: Failure responding to request: StatusCode=401 -- Original Error: autorest/azure: Service returned an error. Status=401 Code="Unknown" Message="Unknown service error" Details=[{"odata.error":{"code":"Authorization_IdentityNotFound","date":"2023-10-02T18:43:00","message":{"lang":"en","value":"The identity of the calling application could not be established."},"requestId":"3df53cfb-0f10-494d-84a9-da86d4348353"}}]
│ 
│   with polaris_azure_service_principal.polaris,
│   on main.tf line 22, in resource "polaris_azure_service_principal" "polaris":
│   22: resource "polaris_azure_service_principal" "polaris" {
  
```

Logout and back in again from Azure"

`az logout`
`az login --tenant [Azure Tenant]`

### Error: failed to add subscription

When the last subscription in an Azure tenant has been deleted you may get this error, as the tenant has also been deleted from RSC:

```╷
│ Error: failed to add subscription: failed to request addAzureCloudAccountWithoutOauth: graphql response body is an error (status code 200): NOT_FOUND: Failed to get service principal in the tenant. Azure may take some time to sync service principal. Please try after a minute (Azure error: [Unknown] Unknown service error) (code: 404, traceId: FWaZk7YsxjaRDF5NlWWsAw==)
│ 
│   with polaris_azure_subscription.polaris,
│   on main.tf line 84, in resource "polaris_azure_subscription" "polaris":
│   84: resource "polaris_azure_subscription" "polaris" {
│ 
╵
```

Solution: Taint the `polaris_azure_service_principal.polaris` resource and re-running the apply operation.

## How You Can Help

We glady welcome contributions from the community. From updating the documentation to adding more functionality, all ideas are welcome. Thank you in advance for all of your issues, pull requests, and comments!

- [Contributing Guide](CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

## Developers

This [README.md](README.md) was created with [terraform-docs](https://github.com/terraform-docs/terraform-docs). To update any of the auto generated parameters between the `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` lines first modify the [.terraform-docs.yml](.terraform-docs.yml) file, if needed. Then run [gen_docs.sh](gen_docs.sh) in this modules directory. For any documentation that needs to be modified outside of the `<!-- BEGIN_TF_DOCS -->` and `<!-- END_TF_DOCS -->` lines, modify this [README.md](README.md) file directly.