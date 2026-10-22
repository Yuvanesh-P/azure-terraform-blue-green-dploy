resource "azurerm_network_interface" "blue" {
  name                = "nic-blue"
  location            = azurerm_resource_group.bg.location
  resource_group_name = azurerm_resource_group.bg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bg.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "green" {
  name                = "nic-green"
  location            = azurerm_resource_group.bg.location
  resource_group_name = azurerm_resource_group.bg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bg.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "blue" {
  name                = "vm-blue"
  resource_group_name = azurerm_resource_group.bg.name
  location            = azurerm_resource_group.bg.location
  size                = var.vm_size
  custom_data         = base64encode(file("${path.module}/../app/blue/cloud-init.yaml"))
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.blue.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    color   = "blue"
    version = "v1"
  }
}

resource "azurerm_linux_virtual_machine" "green" {
  name                = "vm-green"
  resource_group_name = azurerm_resource_group.bg.name
  location            = azurerm_resource_group.bg.location
  size                = var.vm_size
  custom_data         = base64encode(file("${path.module}/../app/green/cloud-init.yaml"))
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.green.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = {
    color   = "green"
    version = "v2"
  }
}
