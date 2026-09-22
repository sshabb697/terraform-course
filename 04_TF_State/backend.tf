terraform {
  backend "azurerm" {
    resource_group_name   = "storagetfstate011"
    storage_account_name  = "kml_rg_main-52ab83f918254310"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
