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
    time = {
      source  = "hashicorp/time"
      version = ">= 0.13.0"
    }
  }
}
