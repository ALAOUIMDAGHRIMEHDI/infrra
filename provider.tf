terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.58.0"
    }
  }
}

  
provider "azurerm" {
  subscription_id = "59d460b9-da91-449c-9c53-0f01f82b5e2f"
  tenant_id       = "52707392-fe79-46d6-ae10-cd8e506f41f9"
  features {}
}