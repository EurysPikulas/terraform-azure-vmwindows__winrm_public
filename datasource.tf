


data "azurerm_resource_group" "vm_rg" {
  name = var.rg 
}


data "azurerm_virtual_network" "vm_vnet" {
  name = var.vnet 
  resource_group_name = var.rg_vnet
}


data "azurerm_subnet" "vm_subnet" {
  name = var.subnet 
  resource_group_name = var.rg_vnet
  virtual_network_name = data.azurerm_virtual_network.vm_vnet.name 
}


