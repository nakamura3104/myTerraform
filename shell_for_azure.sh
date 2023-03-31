

# YOUR_STORAGE_ACCOUNT_NAME: 対象のストレージアカウント名
# YOUR_RESOURCE_GROUP_NAME: ストレージアカウントが含まれるリソースグループ名
# IP_ADDRESS: 許可する任意のIPアドレス
#例えば、ストレージアカウント名がmystorageaccount、リソースグループ名がmyresourcegroupで、許可するIPアドレスが192.168.0.1の場合、次のコマンドを実行します。

az storage account update --name mystorageaccount --resource-group myresourcegroup --add properties.networkAcls.ipRules="[{'action': 'Allow', 'value': '192.168.0.1'}]"



################################################3
#
# Git branch in the CloudShell prompt
#
parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
export PS1="\u@\h:\w\[\033[32m\]\$(parse_git_branch)\[\033[00m\] $ "


################################################3
#
# Get Credential
#

# get access token
az account get-access-token --resource https://management.azure.com/

export ARM_CLIENT_ID=$(az account show --query 'user.name' -o tsv)
export ARM_CLIENT_SECRET=$ACCESS_TOKEN
export ARM_TENANT_ID=$(az account show --query 'tenantId' -o tsv)
export ARM_SUBSCRIPTION_ID=$(az account show --query 'id' -o tsv)

