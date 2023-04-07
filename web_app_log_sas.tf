resource "azurerm_storage_container" "logs" {
  name                  = "webapp-logs"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

data "azurerm_storage_account_sas" "example" {
  connection_string = azurerm_storage_account.example.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start_time  = "2023-04-01T00:00:00Z"
  expiry_time = "2023-04-30T23:59:59Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = false
    process = false
  }
}

resource "azurerm_windows_web_app" "example" {
  # ... (other configuration)
  
  app_settings = {
    "WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" = "ManagedIdentity"
    "WEBSITE_CONTENTSHARE"                     = azurerm_storage_account.example.name
    "DIAGNOSTICS_AZUREBLOBCONTAINERSASURL"     = "${azurerm_storage_container.logs.name}?${data.azurerm_storage_account_sas.example.sas}"
  }

  # ...
}
