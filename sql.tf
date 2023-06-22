resource "azurerm_mssql_server" "mysqlserver" {
  name                         = "mysqlserver4320"
  resource_group_name          = local.resource_groupe_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
  minimum_tls_version          = "1.2"
depends_on = [ azurerm_resource_group.testrsc ]
} 
resource "azurerm_mssql_database" "data" {
  for_each=toset(local.function)
  name           = "${each.key}-data"
  server_id      = azurerm_mssql_server.mysqlserver.id 
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
  depends_on = [ azurerm_mssql_server.mysqlserver ]
}
resource "azurerm_mssql_firewall_rule" "FirewallRule" {
  name             = "FirewallRule"
  server_id        = azurerm_mssql_server.mysqlserver.id
  start_ip_address = "41.137.37.226"
  end_ip_address   = "41.137.37.226"
  depends_on = [ 
    azurerm_mssql_server.mysqlserver
   ]
}
resource "azurerm_mssql_firewall_rule" "allowrsc" {
  name             = "allowrsc"
  server_id        = azurerm_mssql_server.mysqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
  depends_on = [ 
    azurerm_mssql_server.mysqlserver
   ]
}
resource "azurerm_log_analytics_workspace" "wrkspc" {
  name                = "wrkspc01"
  location            = local.location
  resource_group_name = local.resource_groupe_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on = [ azurerm_resource_group.testrsc ]
}
resource "azurerm_mssql_server_extended_auditing_policy" "extendedauditing" {
  server_id  = azurerm_mssql_server.mysqlserver.id
  log_monitoring_enabled= true
depends_on=[azurerm_mssql_database.data]
}
resource "azurerm_monitor_diagnostic_setting" "sett" {
  for_each = toset(local.function)
  name               = "${each.key}-sett"
  target_resource_id = "${azurerm_mssql_database.data[each.key].id}"
log_analytics_workspace_id = azurerm_log_analytics_workspace.wrkspc.id

  enabled_log {
    category = "SQLSecurityAuditEvents"
  
  retention_policy {
      enabled = false
  }
}
depends_on = [ 
    azurerm_log_analytics_workspace.wrkspc,
    azurerm_mssql_database.data
 ]
}
 