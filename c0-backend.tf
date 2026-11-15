terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
  #Remote backend 
  backend "azurerm" {
    use_oidc         = true
    use_azuread_auth = true
  }
}