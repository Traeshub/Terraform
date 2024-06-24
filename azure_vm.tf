# Configuring the Azure provider

provider "azurerm" {
  subscription_id = "sub_id"
  tenant_id = "tenant_id"

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
# Resource block
resource "azurerm_resource_group" "resource_group" {
  name = "terraform-homelab-rg"
  location = "East US"
}

# Defining the virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name = "terraformlab-vnet"
  address_space = ["10.0.0.0/16"]
  location = azurerm_resource_group.resource_group.virtual_network
  resource_group_name = azurerm_resource_group.resource_group.virtual_network.name
}

#Defining the subnet
resource "azurerm_subnet" "subnet" {
  name = "terraformlab-subnet"
  resource_group_name = azurerm_resource_group.resource_group.subnet
  virtual_network_name = azurerm_resource_group.resource_group.subnet.name
  address_prefixes = ["10.0.0.0/24"]
}

# The Network interface
resource "azurerm_network_interface" "network_interface" {
  name = "terraformlab-nic"
  location = azurerm_resource_group.resource_group.network_interface.location
  resource_group_name = azurerm_resource_group.resource_group.network_interface.name

  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Creating the virtual machine
resource "azurerm_windows_virtual_machine" "main" {
  name                  = "terraform-vm"
  admin_username        = "azureuser"
  admin_password        = random_password.password.result
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.my_terraform_nic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "OsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }

boot_diagnostics {
    storage_account_uri = azurerm_storage_account.my_storage_account.primary_blob_endpoint
  }
}