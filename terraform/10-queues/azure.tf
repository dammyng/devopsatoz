provider "azurerm" {
  features {}
}

resource "azurerm_storage_account" "account" {
  name                     = "myaccount"
  resource_group_name      = "myresourcegroup"
  location                 = "westus2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "queue" {
  name                  = "myqueue"
  storage_account_name  = azurerm_storage_account.account.name
  storage_queue_metadata {
    some_metadata = "metadata-value"
  }
}
