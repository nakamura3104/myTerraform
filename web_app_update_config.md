Azure Web Appsの設定を更新するには、Azure REST APIを使用します。具体的には`Web Apps - Update Configuration`というAPIを使用します。

以下に、それを行うための基本的な手順を示します。

1. Azure CLIまたはPowerShellを使用して、Azureにログインします。
   
   Azure CLIの場合:
   
   ```bash
   az login
   ```
   
   PowerShellの場合:
   
   ```powershell
   Connect-AzAccount
   ```
   
2. 必要な情報を収集します。これには、サブスクリプションID、リソースグループ名、およびWebアプリ名が含まれます。

3. これらの情報を使用して、APIのURLを作成します。

   例：

   ```
   https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{name}/config/web?api-version=2021-02-01
   ```

4. APIを呼び出すためのBearerトークンを取得します。これは、アクセス許可を与えるためのものです。

   Azure CLIの場合:
   
   ```bash
   az account get-access-token --query accessToken -o tsv
   ```

   これにより、Bearerトークンが表示されます。

5. 次に、このトークンを使用して、APIを呼び出します。この例では、`curl`を使用しますが、任意のHTTPクライアントを使用できます。

   ```bash
curl -X PATCH \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
  "properties": {
    "minTlsCipherSuite": "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"
  }
}' \
  "https://management.azure.com/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>/providers/Microsoft.Web/sites/<siteName>/config/web?api-version=2022-03-01"
   ```

   ここで、`{token}`はステップ4で取得したBearerトークン、`{your_configuration_json}`は更新したい設定のJSON、`{api_url}`はステップ3で作成したAPIのURLです。

この手順を実行すると、指定したWebアプリの設定が更新されます。この手順は、あなたが管理者権限を持っていて、Webアプリの設定を変更する権限がある場合にのみ機能します。また、実行する前に全ての情報（サブスクリプションID、リソースグループ名、Webアプリ名など）を正確に知っておく必要があります。
