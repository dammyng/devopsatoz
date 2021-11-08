provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "function-app-group"
  location = "eastus"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "functionappstorage"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = azurerm_resource_group.resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "functionapp"
  resource_group_name   = azurerm_resource_group.resource_group.name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

resource "azurerm_function_app" "function_app" {
  name                      = "function-app"
  location                  = azurerm_resource_group.resource_group.location
  resource_group_name       = azurerm_resource_group.resource_group.name
  app_service_plan_id       = "/subscriptions/SUBSCRIPTION_ID/resourceGroups/RESOURCE_GROUP_NAME/providers/Microsoft.Web/serverfarms/APP_SERVICE_PLAN_NAME"
  storage_account_name      = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  https_only                = true
  version                   = "~3"
  site_config {
    always_on = true
  }
}

resource "azurerm_function_app_file_blob" "function_app_blob" {
  name                      = "functionapp.zip"
  function_name             = azurerm_function_app.function_app.name
  storage_account_name      = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key
  storage_container_name    = azurerm_storage_container.storage_container.name
  type                      = "zip"
}

resource "azurerm_function_app_slot" "function_app_slot" {
  name              = "function-app-slot"
  resource_group_name = azurerm_resource_group.resource_group.name
  location          = azurerm_resource_group.resource_group.location
  function_app_name = azurerm_function_app.function_app.name
}
