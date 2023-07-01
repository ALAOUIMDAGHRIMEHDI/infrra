
resource "azurerm_public_ip" "gatewayip" {
  name                = "gateway-ip"
  resource_group_name = local.resource_groupe_name
  location            = local.location
  allocation_method   = "Static" 
  sku="Standard"
  sku_tier = "Regional"
  depends_on = [ azurerm_resource_group.testrsc ]
} 

resource "azurerm_application_gateway" "appgateway" {
  name                = "app-gateway"
  resource_group_name = local.resource_groupe_name
  location            = local.location

  sku {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }
  waf_configuration {
    enabled = true
    firewall_mode = "Detection"
    rule_set_version = "3.0"
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.apsubnet.id
  }

  frontend_port {
    name = "front-end-port"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "front-end-ip-config"
    public_ip_address_id = azurerm_public_ip.gatewayip.id    
  }

  depends_on = [
    azurerm_public_ip.gatewayip,
    azurerm_subnet.apsubnet
  ]
      backend_address_pool {  
      name  = "sqlapp-pool"
     fqdns = ["applicationsql.azurewebsites.net"]
    
    }
   
      backend_http_settings  {
    name                  = "HTTPSetting"
    cookie_based_affinity = "Disabled"
    path                  = ""
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

 http_listener {
    name                           = "gateway-listener"
    frontend_ip_configuration_name = "front-end-ip-config"
    frontend_port_name             = "front-end-port"
    protocol                       = "Http"
  }

 request_routing_rule {
    name               = "RoutingRuleA"
    rule_type          = "PathBasedRouting"
    url_path_map_name  = "RoutingPath"
    http_listener_name = "gateway-listener"    
    priority = 100
  }

  url_path_map {
    name                               = "RoutingPath"    
    default_backend_address_pool_name   = "sqlapp-pool"
    default_backend_http_settings_name  = "HTTPSetting"
   
     path_rule {
      
      name                          = "sqlappRoutingRule"
      backend_address_pool_name     = "sqlapp-pool"
      backend_http_settings_name    = "HTTPSetting"
      paths = [
        "/applicationsql",
      ]
  }
     }
     probe {
       name = "health" 
       protocol = "Http"
       path = "/applicationsql"
       pick_host_name_from_backend_http_settings = true
       interval = "30"
       timeout = "30"
       unhealthy_threshold = "3"
       depends_on = [backend_http_settings.HTTPSetting]
     }
    
  }


