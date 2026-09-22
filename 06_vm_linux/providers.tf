terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.117"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

# AzureRM 2.x called Azure AD Graph (graphrbac) to resolve the
# service principal object ID. Azure DevOps identities usually get 403.
# 3.x uses Microsoft Graph and works with a normal ARM service connection.
provider "azurerm" {
  features {}
  skip_provider_registration = true
}
