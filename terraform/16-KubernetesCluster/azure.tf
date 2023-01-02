# Provider block for Azure
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "k8s-cluster-rg"
  location = "eastus"
}

# Virtual network
resource "azurerm_virtual_network" "example" {
  name                = "k8s-cluster-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  subnet {
    name           = "k8s-subnet"
    address_prefix = "10.0.1.0/24"
  }
}

# Public IP address
resource "azurerm_public_ip" "example" {
  name                = "k8s-cluster-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
}

# Network interface
resource "azurerm_network_interface" "example" {
  name                = "k8s-cluster-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "k8s-nic-ip"
    subnet_id                     = azurerm_virtual_network.example.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# Kubernetes cluster
resource "azurerm_kubernetes_cluster" "example" {
  name                = "example-aks-cluster"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_prefix          = "example-k8s"
  kubernetes_version  = "1.21.2"
  node_resource_group = "k8s-node-rg"

  default_node_pool {
    name            = "default"
    node_count      = 1
    vm_size         = "Standard_DS2_v2"
    vnet_subnet_id  = azurerm_virtual_network.example.subnet.id
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "dev"
  }
}
