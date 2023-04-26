resource "azurerm_windows_web_app" "example" {
  # ... その他の設定 ...

  site_config {
    # ... その他のsite_config設定 ...
  }

  # ... その他の設定 ...
}

resource "azurerm_dns_cname_record" "example" {
  # ... DNS CNAME レコードの設定 ...
}

resource "azurerm_app_service_custom_hostname_binding" "example" {
  app_service_name         = azurerm_windows_web_app.example.name
  resource_group_name      = azurerm_resource_group.example.name
  hostname                 = azurerm_dns_cname_record.example.name
  ssl_state                = "SniEnabled"
  thumbprint               = azurerm_app_service_certificate.example.thumbprint
}

resource "azurerm_app_service_certificate" "example" {
  # ... SSL証明書の設定 ...
}


#### gen 04/26
data "azurerm_key_vault" "example" {
  name                = "<your_key_vault_name>"
  resource_group_name = "<your_key_vault_resource_group>"
}

data "azurerm_key_vault_secret" "example_certificate" {
  name         = "<your_key_vault_certificate_secret_name>"
  key_vault_id = data.azurerm_key_vault.example.id
}

resource "azurerm_app_service_certificate" "example" {
  name                = "example-certificate"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  key_vault_secret_id = data.azurerm_key_vault_secret.example_certificate.id
}

resource "azurerm_app_service_custom_hostname_binding" "example" {
  hostname            = "<your_custom_domain>"
  app_service_name    = azurerm_app_service.example.name
  resource_group_name = azurerm_resource_group.example.name
  ssl_state           = "SniEnabled"
  thumbprint          = azurerm_app_service_certificate.example.thumbprint
}
