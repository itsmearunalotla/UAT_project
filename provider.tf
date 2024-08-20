# Terraform Settings Block
terraform {
  #required_version = "1.4.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.64.0"  # Update the version as needed
    }
  }

  # Adding Backend as Azure Storage for Remote State Storage
  backend "azurerm" {
    resource_group_name   = ""
    storage_account_name  = ""
    container_name        = ""
    key                   = ""
  }
}

# Terraform Provider Block
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
}
