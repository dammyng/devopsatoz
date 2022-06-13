provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = "West US"
  resource_group_name = "example-rg"

  allocation_method = "Dynamic"
  sku               = "Standard"
}
