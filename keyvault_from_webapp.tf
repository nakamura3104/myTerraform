resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Japan East"
}

resource "azurerm_key_vault" "example" {
  name                = "example-keyvault"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-password"
  value        = "my-secure-password"
  key_vault_id = azurerm_key_vault.example.id
}

resource "azurerm_app_service_plan" "example" {
  name                = "example-app-service-plan"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "example-web-app"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    # 他の設定があればここに追加
  }

  app_settings = {
    # Key Vaultから取得したパスワードを環境変数に設定
    "PASSWORD" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.example.id})"
  }

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_key_vault_access_policy" "web_app" {
  key_vault_id = azurerm_key_vault.example.id

  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = azurerm_app_service.example.identity.0.principal_id

  secret_permissions = [
    "get",
  ]
}

data "azurerm_client_config" "current" {}
