provider "azurerm" {
  features {}
}

resource "azurerm_cosmosdb_account" "example" {
  name                = "example-account"
  location            = "East US"
  resource_group_name = azurerm_resource_group.example.name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"
  consistency_policy {
    consistency_level = "Session"
  }
}

resource "azurerm_cosmosdb_sql_database" "example_database" {
  name                = "example-db"
  resource_group_name = azurerm_resource_group.example.name
  account_name        = azurerm_cosmosdb_account.example.name
}
