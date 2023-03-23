provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "example" {
  name                  = "webapp-logs"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-appserviceplan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-appservice"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    app_command_line = ""
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.example.instrumentation_key
    "WEBSITE_NODE_DEFAULT_VERSION"   = "10.14.1"
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  logs {
    application_logs {
      azure_blob_storage {
        level             = "Information"
        sas_url           = "${azurerm_storage_account.example.primary_blob_endpoint}${azurerm_storage_container.example.name}?${azurerm_storage_account.example.primary_access_key}"
        retention_in_days = 30
      }
    }

    http_logs {
      azure_blob_storage {
        sas_url           = "${azurerm_storage_account.example.primary_blob_endpoint}${azurerm_storage_container.example.name}?${azurerm_storage_account.example.primary_access_key}"
        retention_in_days = 30
      }
    }
  }

  tags = {
    environment = "production"
  }
}
