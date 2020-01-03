locals {
  virtual_machine_name = "${var.prefix}"
  admin_username       = "${var.admin_username}"
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
    name                          = "${var.prefix}-ipconfig"
    subnet_id                     = "${data.azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${var.ip_address}"
    public_ip_address_id          = ""
  }
}

data "azurerm_key_vault" "vault" {
  name                        = "${var.vault}"
  resource_group_name         = "${var.rg_vault}"
}    

data "azurerm_key_vault_secret" "secret" {
  name         = "${var.secret}"
  key_vault_id = "${data.azurerm_key_vault.vault.id}"
}

data "azurerm_availability_set" "avset" {
 name                         = "${var.avset}"
 resource_group_name          = "${data.azurerm_resource_group.rg.name}"
}
 
