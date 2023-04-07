# Create the Application Gateway with WAF
resource "azurerm_application_gateway" "appgw" {
  name                = "appgateway"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appgw-ip-configuration"
    subnet_id = azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = "appgw-frontend-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_public_ip.id
  }

  backend_address_pool {
    name = "appgw-backend-pool"
  }

  backend_http_settings {
    name                  = "appgw-backend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "appgw-frontend-port"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "appgw-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "appgw-backend-pool"
    backend_http_settings_name = "appgw-backend-http-settings"
  }

  probe {
    name                = "appgw-custom-probe"
    protocol            = "Http"
    path                = "/"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  # Backend pool addresses
  backend_address_pool_address {
    name      = "backend-address-1"
    fqdn      = "<private-endpoint-fqdn-for-web-app>"
    ip_address = null
  }

  # WAF configuration
  web_application_firewall_configuration {
    enabled                = true
    firewall_mode          = "Prevention"
    rule_set_type          = "OWASP"
    rule_set_version       = "3.1"
    file_upload_limit_mb   = 100
    request_body_check     = true
    max_request_body_size_kb = 128
  }
}


locals {
  input_map = {
    "key1" = "value1"
    "key2" = "value2"
    "key3" = "value3"
  }

  modified_map = {
    for key, value in local.input_map :
    "prefix-${key}" => value
  }
}

output "modified_map" {
  value = local.modified_map
}

  
  #
  # With SSL Cert
  #
  #
  #
  
  
  provider "azurerm" {
  features {}
}

resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  resource_group_name = "<your-resource-group>"
  location            = "eastus"
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_application_gateway" "example" {
  name                = "example-appgw"
  resource_group_name = "<your-resource-group>"
  location            = "eastus"

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "example-gateway-ip-configuration"
    subnet_id = "<your-subnet-id>"
  }

  frontend_port {
    name = "example-frontend-port"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "example-frontend-ip-configuration"
    public_ip_address_id = azurerm_public_ip.example.id
  }

  backend_address_pool {
    name = "example-backend-address-pool"
  }

  backend_http_settings {
    name                  = "example-backend-http-settings"
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "example-http-listener"
    frontend_ip_configuration_name = "example-frontend-ip-configuration"
    frontend_port_name             = "example-frontend-port"
    protocol                       = "Https"
    ssl_certificate_name           = "example-ssl-certificate"
  }

  request_routing_rule {
    name                       = "example-request-routing-rule"
    rule_type                  = "Basic"
    http_listener_name         = "example-http-listener"
    backend_address_pool_name  = "example-backend-address-pool"
    backend_http_settings_name = "example-backend-http-settings"
  }

  ssl_certificate {
    name                = "example-ssl-certificate"
    key_vault_secret_id = "<your-key-vault-certificate-secret-id>"
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      "<your-user-assigned-managed-identity-id>",
    ]
  }
}
