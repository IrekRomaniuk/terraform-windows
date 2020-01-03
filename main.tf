locals {
  custom_data_params  = "Param($ComputerName = \"${local.virtual_machine_name}\")"
  custom_data_content = "${local.custom_data_params} ${file("./files/winrm.ps1")}"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${local.virtual_machine_name}"
  location              = "${data.azurerm_resource_group.rg.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  network_interface_ids = ["${azurerm_network_interface.nic.id}"]
  vm_size               = "${var.vm_size}"

  # This means the OS Disk will be deleted when Terraform destroys the Virtual Machine
  # NOTE: This may not be optimal in all cases.
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "StandardSSD_LRS"
  }

  os_profile {
    computer_name  = "${local.virtual_machine_name}"
    admin_username = "${local.admin_username}"
    admin_password = "${data.azurerm_key_vault_secret.secret.value}"
    custom_data    = "${local.custom_data_content}"
  }

  os_profile_secrets {
    source_vault_id = "${data.azurerm_key_vault.vault.id}"

    vault_certificates {
      certificate_url   = "${var.cert_uri}"
      certificate_store = "My"
    }
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true

    # Auto-Login's required to configure WinRM
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "AutoLogon"
      content      = "<AutoLogon><Password><Value>${data.azurerm_key_vault_secret.secret.value}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${local.admin_username}</Username></AutoLogon>"
    }

    # Unattend config is to enable basic auth in WinRM, required for the provisioner stage.
    additional_unattend_config {
      pass         = "oobeSystem"
      component    = "Microsoft-Windows-Shell-Setup"
      setting_name = "FirstLogonCommands"
      content      = "${file("./files/FirstLogonCommands.xml")}"
    }
  }

  /*
  provisioner "remote-exec" {
    connection {
      user     = "${local.admin_username}"
      password = "${data.azurerm_key_vault_secret.secret.value}"
      port     = 5986
      https    = true
      timeout  = "1m"

      # NOTE: if you're using a real certificate, rather than a self-signed one, you'll want this set to `false`/to remove this.
      insecure = true
      host = "${azurerm_network_interface.nic.private_ip_address}" # 10.4.8.4
    }

    inline = [
      "cd C:\\Windows",
      "dir",
    ]
  }
*/  
}

