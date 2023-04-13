以下は、appsマップのキーをホスト名にしたURLを生成し、ベースURLをazurewebsites.netに設定したTerraformコードの例です。

```hcl
locals {
apps = {
admin-api = "admin"
admin-web = "admin"
service-api = "service"
}

base_domain = "azurewebsites.net"

app_urls = {
for app_name in keys(local.apps) :
app_name => format("https://%s.%s", app_name, local.base_domain)
}
}

output "app_urls" {
value = local.app_urls
}
```

この例では、for式でlocal.appsマップのキー（アプリ名）のみを取得し、format関数を使用してホスト名を含むURLを生成しています。値（アプリのプレフィックス）は使用していません。

この例の実行結果は以下のようになります。

```
app_urls = {
"admin-api" = "https://admin-api.azurewebsites.net"
"admin-web" = "https://admin-web.azurewebsites.net"
"service-api" = "https://service-api.azurewebsites.net"
}
```


 - for_eachで作成したリソースの一括参照

```
variable "web_apps" {
  default = {
    web_app_1 = "web-app-1"
    web_app_2 = "web-app-2"
  }
}

resource "azurerm_windows_web_app" "example" {
  for_each = var.web_apps

  # ... other configuration ...
}

locals {
  web_app_map = {
    for key, value in azurerm_windows_web_app.example :
    key => value
  }
}

```
