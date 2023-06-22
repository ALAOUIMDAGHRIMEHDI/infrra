locals {
  resource_groupe_name="testrsc"
  location="North Europe"
  virtual_network={
   name="vnet"
   address_space="10.0.0.0/16"
  }
  network_interface_name="interface"
  storage_account_name="storage00acc"
  functions = ["videos","sqlapp"]
  function  = ["mssqlest1","mssqlest2"]
}
resource "azurerm_resource_group" "testrsc" {
  name     = local.resource_groupe_name
  location =local.location
} 