
# resource "azurerm_resource_group" "testrsc" {
#   name     = local.resource_group_name
#   location = local.location
# }
resource "azurerm_virtual_network" "vnet" {
  name                = local.virtual_network.name
  resource_group_name = local.resource_groupe_name
  location            = local.location
  address_space       = [local.virtual_network.address_space]

  depends_on = [ azurerm_resource_group.testrsc ]
} 

