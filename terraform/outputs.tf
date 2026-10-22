output "resource_group_name" {
  value = azurerm_resource_group.bg.name
}

output "load_balancer_public_ip" {
  value = azurerm_public_ip.lb.ip_address
}

output "blue_private_ip" {
  value = azurerm_network_interface.blue.private_ip_address
}

output "green_private_ip" {
  value = azurerm_network_interface.green.private_ip_address
}

output "active_color" {
  value = var.active_color
}

output "load_balancer_fqdn" {
  value = azurerm_public_ip.lb.fqdn
}
