Azure AD認証ではなく、マネージドIDを使用してTerraformバックエンドをストレージアカウントに設定する場合は、以下の手順を実行する必要があります。

まず、TerraformのバックエンドをAzureのストレージアカウントに設定します。

```terraform
terraform
Copy code
terraform {
  backend "azurerm" {
    storage_account_name = "examplestorageaccount"
    container_name       = "terraformstate"
    key                  = "terraform.tfstate"
  }
}
```

次に、Terraformが使用するAzureリソースにマネージドIDを割り当てます。例えば、ストレージアカウントにマネージドIDを割り当てるには、以下のようにします。

```terraform
Copy code
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "Japan East"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }
}
```
以上のように、identity ブロックを使用して、ストレージアカウントにマネージドIDを割り当てます。

次に、ストレージアカウントにアクセスするために必要なアクセス許可をマネージドIDに割り当てます。例えば、ストレージアカウントにアクセスするためのロールを割り当てるには、以下のようにします。

```terraform
Copy code
data "azurerm_subscription" "current" {}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_storage_account.example.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_storage_account.example.identity[0].principal_id
}
```
これにより、Terraformがストレージアカウントにアクセスするために必要なアクセス許可がマネージドIDに割り当てられます。

総じて、AzureマネージドIDを使用してTerraformバックエンドをストレージアカウントに設定する場合、Terraformが使用するリソースにマネージドIDを割り当て、ストレージアカウントにアクセスするために必要なアクセス許可をマネージドIDに割り当てる必要があります。
