provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "myresourcegroup" {
  name     = "myresourcegroup"
  location = "East US"
}

resource "azurerm_mysql_server" "mysqldatabase" {
  name                = "my-mysql-server"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  location            = azurerm_resource_group.myresourcegroup.location
  version             = "5.7"

  administrator_login          = "myadmin"
  administrator_login_password = "Password1234!"

  sku {
    name     = "B_Gen5_1"
    capacity = 1
  }

  storage_profile {
    storage_mb            = 5120
    backup_retention_days = 7
    geo_redundant_backup  = "Disabled"
  }
}

resource "azurerm_mysql_database" "mysqldatabase" {
  name                = "mydatabase"
  resource_group_name = azurerm_resource_group.myresourcegroup.name
  server_name         = azurerm_mysql_server.mysqldatabase.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

variable "mysql_admin_username" {
  type = string
}

variable "mysql_admin_password" {
  type = string
}

variable "mysql_database_name" {
  type = string
}
