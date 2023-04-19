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
