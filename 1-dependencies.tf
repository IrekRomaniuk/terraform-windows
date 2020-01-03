locals {
  virtual_machine_name = "${var.prefix}-vm"
  admin_username       = "${var.admin_username}"
  admin_password       = "${var.admin_password}"
}

data "azurerm_resource_group" "rg" {
  name = "${var.rg_vm}"
}

data "azurerm_virtual_network" "vnet" {
  name = "${var.vnet}"
  resource_group_name   = "${var.rg_vnet}"
}

data "azurerm_subnet" "subnet" {
  name = "${var.subnet}"
  virtual_network_name = "${data.azurerm_virtual_network.vnet.name}"
  resource_group_name   = "${var.rg_vnet}"
}


resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-nic"
  location            = "${data.azurerm_resource_group.rg.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = "${data.azurerm_subnet.orion.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip_address}"
    public_ip_address_id          = ""
  }
}
 
