
        ### appgateway subnet ####
        resource "azurerm_subnet" "apsubnet" {
  name                 = "apsubnet"
  resource_group_name  = local.resource_groupe_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Web"]
  depends_on = [ azurerm_resource_group.testrsc,
  azurerm_virtual_network.vnet ]
}
        ### vm subnet ####
 resource "azurerm_subnet" "vmsubnet" {
  name                 = "vmsubnet"
  resource_group_name  = local.resource_groupe_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name =  "service"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      
    }
  }
depends_on = [
      azurerm_resource_group.testrsc,
      azurerm_virtual_network.vnet]
  
 }
        ### loadbalancer subnet ####
resource "azurerm_subnet" "lbsubnet" {
  name                 = "lbsubnet"
  resource_group_name  = local.resource_groupe_name
  virtual_network_name = local.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"] 
  depends_on =[azurerm_resource_group.testrsc,
  azurerm_virtual_network.vnet
  ]
}
        ### sql subnet ####
resource "azurerm_subnet" "sqlsubnet" {
  name                 = "sqlsubnet"
  resource_group_name  = local.resource_groupe_name
  virtual_network_name= local.virtual_network.name
  address_prefixes     = ["10.0.3.0/24"] 
  service_endpoints = ["Microsoft.Sql"]
#   enforce_private_link_endpoint_network_policies = "true"
#   enforce_private_link_service_network_policies = "true"
  depends_on =[azurerm_resource_group.testrsc,
  azurerm_virtual_network.vnet
  ]
}
resource "azurerm_mssql_virtual_network_rule" "virtualnetworkrule" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.mysqlserver.id
  subnet_id = azurerm_subnet.sqlsubnet.id
}