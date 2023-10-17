data "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
  is_hns_enabled           = "true"
}

resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "transaction/exports"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = "null"
}

resource "azurerm_storage_account_network_rules" "example" {
  storage_account_id = azurerm_storage_account.storage.id

  default_action             = "Deny"
  ip_rules                   = ["103.24.21.67"]
  bypass                     = ["AzureServices"]
  private_link_access {
    endpoint_resource_id = "/subscriptions/*/resourcegroups/*/providers/Microsoft.DataFactory/factories/*"
  }
}
