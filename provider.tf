terraform {
  required_version = ">=1.2.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.47.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.36.0"
    }
  }
  backend "local" {}
}

provider "azurerm" {
  features {}
}