##############################################################
# This module allows the creation of a Virtual Machine
##############################################################

locals {
  is_windows = contains(list(var.vm_os_simple, var.vm_os_offer), "WindowsServer") || contains(list(var.vm_os_simple, var.vm_os_offer), "Windows10") ? "true" : "false"
  linux_count = local.is_windows != "true" && var.is_windows_image != "true" && var.data_disk == "false" ? var.vm_instances : 0
  is_windows_nodisk = (var.vm_os_id != "" && var.is_windows_image == "true") || local.is_windows == "true" && var.data_disk == "false" ? true : false
  is_windows_withdisk = (var.vm_os_id != "" && var.is_windows_image == "true") || local.is_windows == "true" && var.data_disk == "true" ? true : false
}

data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

module "os" {
  source       = "github.com/danielscholl/iac-terraform/modules/virtual-machine/os"
  vm_os_simple = var.vm_os_simple
}

resource "random_id" "vm-sa" {
  keepers = {
    vm_hostname = var.vm_hostname
  }

  byte_length = 6
}

resource "azurerm_storage_account" "vm-sa" {
  count = var.boot_diagnostics == "true" ? 1 : 0
  name  = "bootdiag${lower(random_id.vm-sa.hex)}"

  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  account_tier             = element(split("_", var.boot_diagnostics_sa_type), 0)
  account_replication_type = element(split("_", var.boot_diagnostics_sa_type), 1)
  tags                     = var.resource_tags
}

resource "azurerm_virtual_machine" "vm-linux" {
  count                         = local.linux_count
  name                          = "${var.vm_hostname}${count.index}"
  resource_group_name           = data.azurerm_resource_group.main.name
  location                      = data.azurerm_resource_group.main.location
  availability_set_id           = azurerm_availability_set.vm.id
  vm_size                       = var.vm_size
  network_interface_ids         = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_image_reference {
    id        = var.vm_os_id
    publisher = var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""
    offer     = var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""
    sku       = var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""
    version   = var.vm_os_id == "" ? var.vm_os_version : ""
  }

  storage_os_disk {
    name              = "osdisk-${var.vm_hostname}${count.index}"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = var.storage_account_type
  }

  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file(var.ssh_key)
    }
  }

  tags = var.resource_tags

  boot_diagnostics {
    enabled     = var.boot_diagnostics
    storage_uri = var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint) : ""
  }
}

resource "azurerm_virtual_machine" "vm-linux-with-datadisk" {
  count               = local.linux_count
  name                = "${var.vm_hostname}${count.index}"
  resource_group_name = data.azurerm_resource_group.main.name
  location            = data.azurerm_resource_group.main.location

  availability_set_id           = azurerm_availability_set.vm.id
  vm_size                       = var.vm_size
  network_interface_ids         = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_image_reference {
    id        = var.vm_os_id
    publisher = var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""
    offer     = var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""
    sku       = var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""
    version   = var.vm_os_id == "" ? var.vm_os_version : ""
  }

  storage_os_disk {
    name              = "${var.vm_hostname}${count.index}-os"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = var.storage_account_type
  }

  storage_data_disk {
    name              = "${var.vm_hostname}${count.index}-data"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = var.data_disk_size_gb
    managed_disk_type = var.data_sa_type
  }

  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = file(var.ssh_key)
    }
  }

  tags = var.resource_tags

  boot_diagnostics {
    enabled     = var.boot_diagnostics
    storage_uri = var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint) : ""
  }
}

resource "azurerm_virtual_machine" "vm-windows" {
  count                         = (var.vm_os_id != "" && var.is_windows_image == "true") || local.is_windows == "true" && var.data_disk == "false" ? var.vm_instances : 0
  name                          = "${var.vm_hostname}${count.index}"
  resource_group_name           = data.azurerm_resource_group.main.name
  location                      = data.azurerm_resource_group.main.location
  availability_set_id           = azurerm_availability_set.vm.id
  vm_size                       = var.vm_size
  network_interface_ids         = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_image_reference {
    id        = var.vm_os_id
    publisher = var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""
    offer     = var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""
    sku       = var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""
    version   = var.vm_os_id == "" ? var.vm_os_version : ""
  }

  storage_os_disk {
    name              = "${var.vm_hostname}${count.index}-os"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = var.storage_account_type
  }

  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.resource_tags

  os_profile_windows_config {
    provision_vm_agent = true
  }

  boot_diagnostics {
    enabled     = var.boot_diagnostics
    storage_uri = var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint) : ""
  }
}

resource "azurerm_virtual_machine" "vm-windows-with-datadisk" {
  count                         = (var.vm_os_id != "" && var.is_windows_image == "true") || local.is_windows == "true" && var.data_disk == "true" ? var.vm_instances : 0
  name                          = "${var.vm_hostname}${count.index}"
  resource_group_name           = data.azurerm_resource_group.main.name
  location                      = data.azurerm_resource_group.main.location
  availability_set_id           = azurerm_availability_set.vm.id
  vm_size                       = var.vm_size
  network_interface_ids         = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  storage_image_reference {
    id        = var.vm_os_id
    publisher = var.vm_os_id == "" ? coalesce(var.vm_os_publisher, module.os.calculated_value_os_publisher) : ""
    offer     = var.vm_os_id == "" ? coalesce(var.vm_os_offer, module.os.calculated_value_os_offer) : ""
    sku       = var.vm_os_id == "" ? coalesce(var.vm_os_sku, module.os.calculated_value_os_sku) : ""
    version   = var.vm_os_id == "" ? var.vm_os_version : ""
  }

  storage_os_disk {
    name              = "${var.vm_hostname}${count.index}-os"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = var.storage_account_type
  }

  storage_data_disk {
    name              = "${var.vm_hostname}${count.index}-data"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = var.data_disk_size_gb
    managed_disk_type = var.data_sa_type
  }

  os_profile {
    computer_name  = "${var.vm_hostname}${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  tags = var.resource_tags

  os_profile_windows_config {}

  boot_diagnostics {
    enabled     = var.boot_diagnostics
    storage_uri = var.boot_diagnostics == "true" ? join(",", azurerm_storage_account.vm-sa.*.primary_blob_endpoint) : ""
  }
}

resource "azurerm_availability_set" "vm" {
  name                         = "${var.vm_hostname}-avset"
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_public_ip" "vm" {
  count                        = var.public_ip_instances
  name                         = "${var.vm_hostname}${count.index}-ip"
  resource_group_name          = data.azurerm_resource_group.main.name
  location                     = data.azurerm_resource_group.main.location
  allocation_method            = var.public_ip_address_allocation
  domain_name_label            = element(var.public_ip_dns, count.index)
}

resource "azurerm_network_interface" "vm" {
  count                     = var.vm_instances
  name                      = "${var.vm_hostname}${count.index}-nic"
  resource_group_name       = data.azurerm_resource_group.main.name
  location                  = data.azurerm_resource_group.main.location
  network_security_group_id = var.nsg_id

  ip_configuration {
    name                          = "ipconfig${count.index}"
    subnet_id                     = var.vnet_subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = length(azurerm_public_ip.vm.*.id) > 0 ? element(concat(azurerm_public_ip.vm.*.id, list("")), count.index) : ""
  }
}

resource "azurerm_virtual_machine_extension" "vm-windows" {
  count                = local.is_windows_nodisk && var.custom_script != "" ? var.vm_instances : 0
  name                 = "bootstrap"
  virtual_machine_id   = element(concat(azurerm_virtual_machine.vm-windows.*.id, list("")), count.index)
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  # settings = <<SETTINGS
  #   {
  #       "script": "${filebase64(var.custom_script)}"
  #   }
  # SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "commandToExecute": "powershell.exe -Command \"./bootstrap.ps1; exit 0;\""
    }
  PROTECTED_SETTINGS

  settings = <<SETTINGS
    {
        "fileUris": [
          "${var.custom_script}"
        ]
    }
  SETTINGS
}
