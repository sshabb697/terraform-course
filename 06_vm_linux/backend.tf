# Values come from the Azure DevOps pipeline (-backend-config).
# Create the storage account once. See 06_vm_linux/PIPELINE.md
terraform {
  backend "azurerm" {
    resource_group_name   = "storagetfstate011"
    storage_account_name  = "kml_rg_main-52ab83f918254310"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}


