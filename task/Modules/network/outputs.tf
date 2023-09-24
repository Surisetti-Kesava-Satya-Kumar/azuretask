output "virtual_network_id" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.example.id
}

output "azurerm_public_ip" {
  description = "ID of the virtual network."
  value       = azurerm_virtual_network.example.id
}

output "resource_group_name" {
  value = azurerm_resource_group.example.name
}


output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = azurerm_subnet.public.id
}

output "public_subnet" {
  description = "Reference to the public subnet resource."
  value       = azurerm_subnet.public
}
