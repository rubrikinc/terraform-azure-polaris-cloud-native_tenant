terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.15.0"
    }
    polaris = {
      source  = "rubrikinc/polaris"
      version = "=1.1.0-beta.5"
    }
  }
}

variable "azure_tenant_id" {
    type        = string
    description = "Azure tenant ID."
}

variable "polaris_credentials" {
  type        = string
  description = "RSC service account credentials or the path to a file containing the service account credentials."
}

provider "azuread" {
  tenant_id = var.azure_tenant_id
}

provider "polaris" {
  credentials = var.polaris_credentials
}

module "polaris_azure_cloud_native_tenant" {
  source = "../.."
}
