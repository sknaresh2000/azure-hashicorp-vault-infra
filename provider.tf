terraform {
  required_version = ">=1.2.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.47.0"
    }
  }
  backend "local" {}
  //backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  # client_id                   = "b8529857-ba8c-4b81-960b-b5005523e1b6"
  # client_certificate          = var.client_certificate
  # client_certificate_password = "tester"
  # tenant_id                   = "09470d96-7a2c-4949-89ba-16cd423a4a1b"
  # subscription_id             = "8ef5de46-f9bc-4c09-9d3a-8169b611cd76"
}

# variable "client_certificate" {
#   default = "/Users/naresh/Downloads/sp.pfx"
# }