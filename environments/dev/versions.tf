terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.77.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.4.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "=4.0.4"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-core-boot"
    storage_account_name = "stcoretfstate64ev6s"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}