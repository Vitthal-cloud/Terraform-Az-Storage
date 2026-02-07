resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
  
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet-demo"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_network_security_rule" "inbound" {
    for_each = var.allowed_ports

  name                        = "Allow-Port-${each.value}"
  priority                    = 100 + each.value
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges     = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_resource_group.rg.name
}

resource "azurerm_public_ip" "pip" {
  count               = var.vm_config.enable_public_ip ? 1 : 0
  name                = "pip-${var.vm_config.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "static"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-${var.vm_config.name}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.vm_config.enable_public_ip ? azurerm_public_ip.pip[0].id : null
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_config.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.vm_config.size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb        = var.vm_config.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  disable_password_authentication = true

  tags = var.tags
}

