# A personal HCL project file, to start my existing Azure VM via terraform

provider "azurerm" {
  features {}
}

# Data source to reference the existing VM
data "azurerm_virtual_machine" "existing_vm" {
  name                 = "LinuxHomelab"
  resource_group_name  = "Homelab"
}

#Manage the VM's state
resource "azurerm_virtual_machine" "existing_vm" {
  name                  = data.azurerm_virtual_machine.existing_vm.name
  location              = "East US (Zone 1)"
  resource_group_name   = data.azurerm_virtual_machine.existing_vm.resource_group_name
  network_interface_ids = "linuxhomelab601_z1"
  vm_size               = "Standard B1s (1 vcpu, 1 GiB memory)"

  storage_os_disk {
    name              = "LinuxHomelab_disk1_5048de8c5bff4d2cb55e7f19f798804a"
    create_option     = "FromImage"
    os_type           = "Linux"
    caching           = "ReadWrite"
  }
}