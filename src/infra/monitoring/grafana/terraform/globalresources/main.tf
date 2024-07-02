terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.106.1"
    }
  }

  // using azure storage for storing backend state for terraform
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}