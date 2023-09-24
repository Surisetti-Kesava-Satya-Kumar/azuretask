resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "example" {
  name                = "${var.environment}-vn"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
}

# Define subnets and other network resources here.
resource "azurerm_subnet" "public" {
  name                 = "${var.environment}-public"
  resource_group_name  =  azurerm_resource_group.example.name
 virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_subnet" "private" {
  name                 = "${var.environment}-private"
  resource_group_name  =  azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "public" {
  name                = "${var.environment}-public-nic"
  location            = "${var.location}"
  resource_group_name =  azurerm_resource_group.example.name
  ip_configuration {
    name                          = "${var.environment}-public-ip-config"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id           = azurerm_public_ip.example.id
  }
}
resource "azurerm_network_interface" "private" {
  name                = "${var.environment}-private-nic"
  location            = "${var.location}"
  resource_group_name =  azurerm_resource_group.example.name
  ip_configuration {
    name                          = "${var.environment}-private-ip-config"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "public_vm" {
  name                = "${var.environment}-public-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.public.id]

  os_disk {
    name              = "${var.environment}-public-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "private_vm" {
  name                = "${var.environment}-private-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [azurerm_network_interface.private.id]

  os_disk {
    name              = "${var.environment}-private-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_public_ip" "example" {
  name                = "${var.environment}-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
  idle_timeout_in_minutes = 30
}