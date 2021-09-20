provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "postgres" {
  name     = "my-postgres-group"
  location = "westus2"
}

resource "azurerm_postgresql_server" "postgres" {
  name                = "my-postgres-server"
  resource_group_name = azurerm_resource_group.postgres.name
  location            = azurerm_resource_group.postgres.location
  version             = "9.6"

  administrator_login          = "myadminuser"
  administrator_login_password = "H@Sh1CoR3!"
}

resource "azurerm_postgresql_database" "postgres" {
  name                = "my-postgres-db"
  resource_group_name = azurerm_resource_group.postgres.name
  server_name         = azurerm_postgresql_server.postgres.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}
