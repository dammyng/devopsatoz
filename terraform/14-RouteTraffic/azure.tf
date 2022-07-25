# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "lb_rg" {
  name     = "my-lb-resource-group"
  location = "West US"
}

# Create a virtual network
resource "azurerm_virtual_network" "lb_vnet" {
  name                = "my-lb-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
}

# Create a subnet
resource "azurerm_subnet" "lb_subnet" {
  name                 = "my-lb-subnet"
  resource_group_name  = azurerm_resource_group.lb_rg.name
  virtual_network_name = azurerm_virtual_network.lb_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "lb_public_ip" {
  name                = "my-lb-public-ip"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  allocation_method   = "Dynamic"
}

# Create a load balancer
resource "azurerm_lb" "lb" {
  name                = "my-lb"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_public_ip.id
  }

  backend_address_pool {
    name = "my-lb-backend-pool"
  }

  probe {
    name                = "my-lb-probe"
    protocol            = "Tcp"
    port                = 80
    interval_in_seconds = 5
    number_of_probes    = 2
  }

  load_balancing_rule {
    name                           = "my-lb-rule"
    frontend_ip_configuration_name = "PublicIPAddress"
    backend_address_pool_name      = "my-lb-backend-pool"
    probe_name                     = "my-lb-probe"
    protocol                       = "Tcp"
    frontend_port                  = 80
    backend_port                   = 80
  }
}

# Create a virtual machine scale set
resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "my-vmss"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  sku                 = "Standard_DS1_v2"

  instance_count = 2

  upgrade_policy_mode = "Automatic"

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name = "vmss-nic"

    ip_configuration {
      name                          = "ipconfig1"
      load_balancer_backend_address_pool_ids = [azurerm_lb.lb.backend_address_pool_ids[0]]
      load_balancer_inbound_nat_rules_ids   = [azurerm_lb.lb.inbound_nat_rules_ids[0]]
      subnet_id                     = azurerm_subnet.lb_subnet.id
    }
  }

}