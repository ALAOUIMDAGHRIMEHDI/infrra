# resource "azurerm_network_security_group" "vnsg" {
#   name                = "v-nsg"
#   location            = local.location
#   resource_group_name = local.resource_groupe_name
#   security_rule {
#     name                       = "RDP"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "HTTP"
#     priority                   = 300
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   depends_on = [ azurerm_virtual_network.vnet ]
# }
# resource "azurerm_subnet_network_security_group_association" "linkvmnsg" {
#   subnet_id                 = azurerm_subnet.vmsubnet.id
#   network_security_group_id = azurerm_network_security_group.vnsg.id
# depends_on = [
#     azurerm_virtual_network.vnet,
#     azurerm_network_security_group.vnsg
#   ]
# }

# resource "azurerm_network_security_group" "appgatewaynsg" {
#   name                = "appgateway-nsg"
#   location            = local.location
#   resource_group_name = local.resource_groupe_name
#   security_rule {
#     name                       = "allow"
#     priority                   = 200
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "65200"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   security_rule {
#     name                       = "alow"
#     priority                   = 210
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "65535"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }
# resource "azurerm_subnet_network_security_group_association" "linkappnsg" {
#   subnet_id                 = azurerm_subnet.appsubnet.id
#   network_security_group_id = azurerm_network_security_group.appgatewaynsg.id
# depends_on = [
#     azurerm_virtual_network.vnet,
#     azurerm_network_security_group.appgatewaynsg
#   ]
# }
 
resource "azurerm_network_security_group" "sqlnsg" {
  name                = "sql-nsg"
  location            = local.location
  resource_group_name = local.resource_groupe_name
  security_rule {
    name                       = "allowsql"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [ azurerm_resource_group.testrsc ]
}
resource "azurerm_subnet_network_security_group_association" "linklbnsg" {
  subnet_id                 = azurerm_subnet.sqlsubnet.id
  network_security_group_id = azurerm_network_security_group.sqlnsg.id
depends_on = [
    azurerm_virtual_network.vnet,
    azurerm_network_security_group.sqlnsg
  ]
}