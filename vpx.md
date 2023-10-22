```hcl

resource "azurerm_virtual_machine" "example" {
  name                  = "${var.vmN}${count.index}"
  location              = "${azurerm_resource_group.example.location}"
  resource_group_name   = "${azurerm_resource_group.example.name}"
  vm_size               = "${var.vmSize}"
  count                 = 2

  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "citrix"
    offer     = "${var.ADCVersion}"
    sku       = "${var.vmSku}"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.vmN}${count.index}"
    admin_username = "${var.adminUsername}"
    admin_password = "${var.adminPassword}"
  }

  network_interface_ids = [
    "${azurerm_network_interface.example1[count.index].id}",
    "${azurerm_network_interface.example2[count.index].id}",
    "${azurerm_network_interface.example3[count.index].id}",
  ]

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.example.primary_blob_endpoint}"
  }

  plan {
    publisher = "citrix"
    product   = "${var.ADCVersion}"
    name      = "${var.vmSku}"
  }

  tags = {
    environment = "Production"
  }
}

resource "azurerm_lb" "example" {
  name                = "[variables('lbN')]"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  frontend_ip_configuration {
    name                 = "example-lb-frontend"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

#ストレージアカウント
hcl
Copy code
resource "azurerm_storage_account" "example" {
  name                     = "[variables('saN')]"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#仮想ネットワーク

resource "azurerm_virtual_network" "example" {
  name                = "[parameters('vnetName')]"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}
ネットワークインターフェース
hcl
Copy code
resource "azurerm_network_interface" "example" {
  name                = "[concat(variables('nicN'), '0', '-01')]"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}
パブリック IP アドレス
hcl
Copy code
resource "azurerm_public_ip" "example" {
  name                = "[concat(variables('vmN'), copyIndex(), variables('mgmt-pipN-suffix'))]"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}
ネットワークセキュリティグループ
hcl
Copy code
resource "azurerm_network_security_group" "example" {
  name                = "[concat(variables('nsgN'), copyIndex(), '-01')]"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

```
