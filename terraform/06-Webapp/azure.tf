# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"
}

# Create an App Service plan
resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Free"
    size = "F1"
  }
}

# Create an App Service web app
resource "azurerm_app_service" "example" {
  name                = "example-web-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    dotnet_framework_version = "v4.0"
    scm_type                 = "LocalGit"
  }

  app_settings = {
    "WEBSITE_TIME_ZONE" = "UTC"
  }

  connection_string {
    name  = "MyDatabase"
    type  = "SQLServer"
    value = "Server=tcp:my-server.database.windows.net,1433;Initial Catalog=my-db;Persist Security Info=False;User ID=my-user;Password=my-password;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}
