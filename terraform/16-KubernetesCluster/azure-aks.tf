provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "k8s_rg" {
  name     = "k8s-rg"
  location = "eastus"
}

module "aks" {
  source              = "Azure/aks/azurerm"
  resource_group_name = azurerm_resource_group.k8s_rg.name
  cluster_name        = "k8s-cluster"
  dns_prefix          = "k8s-cluster"

  agent_pool_profiles = [
    {
      name            = "default"
      count           = 3
      vm_size         = "Standard_DS2_v2"
      os_disk_size_gb = 30
    }
  ]

  service_principal {
    client_id     = "<client-id>"
    client_secret = "<client-secret>"
  }

  tags = {
    environment = "test"
  }
}
