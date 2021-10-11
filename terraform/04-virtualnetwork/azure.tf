# Define provider configuration
provider "azurerm" {
  features {}
}

# Create resource group
resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "East US"
}

# Create virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # Create subnet
  subnet {
    name           = "example-subnet"
    address_prefix = "10.0.1.0/24"
  }
}

# Output virtual network details
output "virtual_network_id" {
  value = azurerm_virtual_network.example.id
}
