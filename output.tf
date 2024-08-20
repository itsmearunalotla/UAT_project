output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.vnet.id
}

output "public_subnet_ids" {
  description = "Public Subnet Id's"
  value       = azurerm_subnet.public_subnets.*.id
}

output "lb_private_subnet_ids" {
  description = "Private Subnet Id's"
  value       = azurerm_subnet.private_lb_subnets.*.id
}

output "app_private_subnet_ids" {
  description = "Private Subnet Id's"
  value       = azurerm_subnet.private_app_subnets.*.id
}

output "db_private_subnet_ids" {
  description = "Private Subnet Id's"
  value       = azurerm_subnet.private_db_subnets.*.id
}

output "vpce_private_subnet_ids" {
  description = "Private Subnet Id's"
  value       = azurerm_subnet.private_vpce_subnets.*.id
}

output "tgw_private_subnet_ids" {
  description = "Private Subnet Id's"
  value       = azurerm_subnet.private_tgw_subnets.*.id
}
