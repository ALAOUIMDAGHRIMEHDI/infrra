resource "azurerm_service_plan" "firstplan" {
  name                = "firstplan"
  resource_group_name = local.resource_groupe_name
  location            = local.location
  sku_name            = "S1"
  os_type             = "Windows"
  depends_on          = [azurerm_resource_group.testrsc]
}

resource "azurerm_windows_web_app" "applicationsql" {
  name                = "applicationsql"
  resource_group_name = local.resource_groupe_name
  location            = local.location
  service_plan_id     = azurerm_service_plan.firstplan.id
  virtual_network_subnet_id = azurerm_subnet.vmsubnet.id

  site_config {
    application_stack {
      current_stack   = "dotnet"
      dotnet_version  = "v6.0"
    }
    vnet_route_all_enabled = true
  }
}
  # ip_restriction {
  #   name        = "permit"
  #   priority    = "110"
  #   action      = "Allow"
  #   tag         = "Default"
  #   description = "Isolate traffic to subnet containing Azure Application Gateway"
  #  depends_on=[azurerm_windows_web_app.applicationsql]
  #     }



resource "azurerm_app_service_source_control" "srccntrl" {
  app_id                  = azurerm_windows_web_app.applicationsql.id 
  repo_url                = "https://github.com/ALAOUIMDAGHRIMEHDI/app.git"
  branch                  = "main"
  use_manual_integration  = true
}
