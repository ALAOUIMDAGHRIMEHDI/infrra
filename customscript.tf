  resource "azurerm_storage_account" "storage00acc" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_groupe_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on = [ azurerm_resource_group.testrsc ]
  }

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = local.storage_account_name
  container_access_type = "blob"
  depends_on = [ azurerm_storage_account.storage00acc,
    azurerm_resource_group.testrsc
   ]

}
    
# resource "azurerm_storage_blob" "IISConfig" {
#   for_each = toset(local.functions)
#   name                   = "IIS_Config_${each.key}.ps1"
#   storage_account_name   = "storage00acc"
#   storage_container_name = "data"
#   type                   = "Block"
#   source                 = "IIS_Config_${each.key}.ps1"
#    depends_on=[azurerm_storage_container.data,
#     azurerm_storage_account.storage00acc]
# }
# resource "azurerm_virtual_machine_extension" "vmextension" {
#   for_each = toset(local.functions)
#   name                 = "${each.key}-extension"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm[each.key].id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.9"
#   depends_on = [
#     azurerm_storage_blob.IISConfig,
#     azurerm_windows_virtual_machine.vm,
#     azurerm_resource_group.testrsc
#   ]
#   settings = <<SETTINGS
#     {
#         "fileUris": ["https://${azurerm_storage_account.storage00acc.name}.blob.core.windows.net/data/IIS_Config_${each.key}.ps1"],
#           "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config_${each.key}.ps1"     
#     }
# SETTINGS

# }
