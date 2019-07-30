data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "orion" {
  name                = "${var.vault}"
  resource_group_name = "${var.rg_vault}"
}

