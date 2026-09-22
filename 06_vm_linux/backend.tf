# Values come from the Azure DevOps pipeline (-backend-config).
# Create the storage account once. See 06_vm_linux/PIPELINE.md
terraform {
  backend "azurerm" {}
}
