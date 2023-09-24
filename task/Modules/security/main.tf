resource "azurerm_network_security_group" "paa" {
  name                = "${var.environment}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  security_rule {
    name                       = "Allow_SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_RDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  dynamic "security_rule" {
    for_each = var.environment == "prod" ? [1] : []
    content {
      name                       = "MonitorRule"
      priority                   = 1003
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
resource "azurerm_subnet_network_security_group_association" "public" {
  for_each              = var.public_subnets
  subnet_id             = var.public_subnets[each.key].id
  network_security_group_id = azurerm_network_security_group.paa.id
}
