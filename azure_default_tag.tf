
locals {
  common_tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}


resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "East US"

  tags = merge(local.common_tags, {
    ResourceType = "ResourceGroup"
  })
}

resource "azurerm_virtual_network" "example" {
  name                = "example-virtual-network"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]

  tags = merge(local.common_tags, {
    ResourceType = "VirtualNetwork"
  })
}
