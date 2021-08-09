# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create an Azure VM
resource "azurerm_virtual_machine" "example" {
  name                  = "example-vm"
  location              = "eastus"
  resource_group_name   = "example-group"
  network_interface_ids = [azurerm_network_interface.example.id]

  vm_size = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_disk {
    name                 = "example-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username = "exampleuser"
  admin_password = "password1234!"
}

# Create a network interface for the VM
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = "eastus"
  resource_group_name = "example-group"

  ip_configuration {
    name                          = "example-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a subnet for the VM
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = "example-group"
  virtual_network_name = "example-vnet"
  address_prefixes     = ["10.0.1.0/24"]
}
