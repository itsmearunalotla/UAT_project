provider "azurerm" {
  features = {}
}


resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vpc_name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vpc_cidr]

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-vnet",
  })
}
resource "azurerm_subnet" "public_subnets" {
  count                = length(var.public_subnets_cidr)
  name                 = "${var.vpc_name}-public-sub-${format("%02d", count.index + 1)}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.public_subnets_cidr, count.index)]

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-public-sub-${format("%02d", count.index + 1)}",
  })
}
resource "azurerm_nat_gateway" "nat_gw" {
  name                = "${var.vpc_name}-nat-gw"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-nat-gw",
  })
}

resource "azurerm_nat_gateway_public_ip_association" "nat_gw_assoc" {
  count                = length(var.public_subnets_cidr)
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.public_ip[count.index].id
}
resource "azurerm_route_table" "public_rtb" {
  name                = "${var.vpc_name}-public-rtb"
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-public-rtb",
  })
}

resource "azurerm_route" "internet_route" {
  name                   = "internet-route"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.public_rtb.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "Internet"

  depends_on = [azurerm_route_table.public_rtb]
}

resource "azurerm_subnet_route_table_association" "pub_rtb_assoc" {
  count                = length(var.public_subnets_cidr)
  subnet_id            = azurerm_subnet.public_subnets[count.index].id
  route_table_id       = azurerm_route_table.public_rtb.id
}
resource "azurerm_subnet" "private_subnets" {
  count                = length(var.private_subnets_cidr)
  name                 = "${var.vpc_name}-private-sub-${format("%02d", count.index + 1)}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.private_subnets_cidr, count.index)]

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-private-sub-${format("%02d", count.index + 1)}",
  })
}
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vpc_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-nsg",
  })
}

resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  count                = length(var.public_subnets_cidr)
  subnet_id            = azurerm_subnet.public_subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_private_endpoint" "private_endpoint" {
  count                   = length(var.private_endpoints)
  name                    = "${var.vpc_name}-private-endpoint-${format("%02d", count.index + 1)}"
  location                = var.location
  resource_group_name     = var.resource_group_name
  subnet_id               = azurerm_subnet.private_subnets[count.index].id
  private_service_connection {
    name                           = "${var.vpc_name}-connection"
    is_manual_connection           = false
    private_connection_resource_id = element(var.private_endpoints, count.index)
    subresource_names              = ["blob"]  # adjust based on service
  }

  tags = merge(local.custom_tags, {
    Name = "${var.vpc_name}-private-endpoint-${format("%02d", count.index + 1)}",
  })
}
