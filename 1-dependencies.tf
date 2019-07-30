locals {
  virtual_machine_name = "${var.prefix}-vm"
  admin_username       = "${var.admin_username}"
  admin_password       = "${var.admin_password}"
}

data "azurerm_resource_group" "orion" {
  name = "net-spoke-eastus-prod-monitoring"
}

data "azurerm_virtual_network" "orion" {
  name = "vnet-eastus-prod-mon"
  resource_group_name = "${data.azurerm_resource_group.orion.name}"
}

data "azurerm_subnet" "orion" {
  name = "orion"
  resource_group_name = "${data.azurerm_resource_group.orion.name}"
  virtual_network_name = "${data.azurerm_virtual_network.orion.name}"
}


resource "azurerm_network_interface" "orion" {
  name                = "${var.prefix}-nic"
  location            = "${data.azurerm_resource_group.orion.location}"
  resource_group_name = "${data.azurerm_resource_group.orion.name}"

  ip_configuration {
    name                          = "configuration"
    subnet_id                     = "${data.azurerm_subnet.orion.id}"
    private_ip_address_allocation = "Static"
    private_ip_address            = "${cidrhost("10.4.4.0/24", 14)}"
  }
}
