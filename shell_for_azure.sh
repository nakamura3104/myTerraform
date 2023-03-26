
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

