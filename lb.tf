
resource "azurerm_lb" "lbrsc" {
  name                = "lb-rsc"
  location            = local.location
  resource_group_name = local.resource_groupe_name
  sku = "Standard"
  sku_tier = "Regional"
  frontend_ip_configuration {
    name       = "frontendip"
    subnet_id  = azurerm_subnet.lbsubnet.id
  }
  depends_on = [ azurerm_subnet.lbsubnet,
  azurerm_resource_group.testrsc
   ]
}
resource "azurerm_network_interface" "lbinterface" {
  name                = "lb-interface"
  location            = local.location
  resource_group_name = local.resource_groupe_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lbsubnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.0.2.8"
 
 }
 depends_on = [ azurerm_virtual_network.vnet]
}
resource "azurerm_lb_backend_address_pool" "poolA" {
  name            = "pool-A"
  loadbalancer_id =azurerm_lb.lbrsc.id
  depends_on = [ azurerm_lb.lbrsc ]
}
resource "azurerm_lb_backend_address_pool_address" "addpoolA" {
  name                    = "addpoolA"
  backend_address_pool_id = azurerm_lb_backend_address_pool.poolA.id
  virtual_network_id      = azurerm_virtual_network.vnet.id
  ip_address              = "10.0.3.0"
  depends_on = [ azurerm_virtual_network.vnet,
  azurerm_resource_group.testrsc,
  azurerm_lb_backend_address_pool.poolA
  ]
}

resource "azurerm_lb_probe" "probeA" {
  loadbalancer_id = azurerm_lb.lbrsc.id
  name            = "probeA"
  port            = 1433
  protocol        ="Tcp"
  depends_on = [ azurerm_lb.lbrsc ]
}


resource "azurerm_lb_rule" "ruleA" {
  loadbalancer_id                = azurerm_lb.lbrsc.id
  name                           = "ruleA"
  protocol                       = "Tcp"
  frontend_port                  = 1433
  backend_port                   = 1433
  frontend_ip_configuration_name = "frontendip"
  probe_id = azurerm_lb_probe.probeA.id
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.poolA.id]
depends_on = [ azurerm_lb.lbrsc ]
}