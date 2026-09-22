# State storage lives in the existing lab resource group.
# Storage account names cannot contain hyphens.
terraform {
  backend "azurerm" {
    resource_group_name  = "kml_rg_main-52ab83f918254310"
    storage_account_name = "storagetfstate011"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
