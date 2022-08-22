provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "East US"
}

resource "azurerm_cdn_profile" "cdn_profile" {
  name                = "my-cdn-profile"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_Verizon"
}

resource "azurerm_cdn_endpoint" "cdn_endpoint" {
  name                = "my-cdn-endpoint"
  location            = azurerm_resource_group.rg.location
  profile_name        = azurerm_cdn_profile.cdn_profile.name
  resource_group_name = azurerm_resource_group.rg.name
  origin {
    name             = "my-origin"
    host_name        = "my-vm.azurewebsites.net"
    http_port        = 80
    https_port       = 443
    content_path     = "/"
    origin_host_header = "my-vm.azurewebsites.net"
  }
  delivery_rule {
    order = 1
    request_scheme_condition {
      operator = "Equal"
      match_values = [
        "HTTP",
      ]
    }
    cache_behavior {
      cache_duration_seconds = 86400
      dynamic_compression = "Enabled"
      query_string_caching_behavior = "IgnoreQueryString"
      header_action = "Append"
      headers = {
        "X-Custom-Header" = "Custom-Value"
      }
    }
  }
}
