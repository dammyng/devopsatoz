provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "West US"
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"

  tags = {
    environment = "example"
  }
}

resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  tags = {
    environment = "example"
  }
}

resource "azurerm_lb_backend_address_pool" "example" {
  name                = "example-backend-pool"
  loadbalancer_id     = azurerm_lb.example.id
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "example"
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count = var.vm_count

  network_interface_id    = element(azurerm_network_interface.example.*.id, count.index)
  ip_configuration_name   = "ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id

  depends_on = [
    azurerm_lb_backend_address_pool.example,
    azurerm_network_interface.example,
  ]

  tags = {
    environment = "example"
  }
}

