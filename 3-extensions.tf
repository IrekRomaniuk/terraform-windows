resource "azurerm_virtual_machine_extension" "disk-encryption" {
  name                 = "DiskEncryption"
  location             = "${data.azurerm_resource_group.rg.location}"
 resource_group_name = "${data.azurerm_resource_group.rg.name}"
  virtual_machine_name = "${data.azurerm_virtual_machine.vm}"
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"

  settings = <<SETTINGS
{
  "EncryptionOperation": "EnableEncryption",
  "KeyVaultURL": "https://${var.vault}.vault.azure.net",
  "KeyVaultResourceId": "${data.azurerm_key_vault.vault.id}"
  "KeyEncryptionKeyURL": "${var.vault_uri}",
  "KeyEncryptionAlgorithm": "RSA-OAEP",
  "VolumeType": "All"
}
SETTINGS
depends_on = ["azurerm_virtual_machine.vm"]
}