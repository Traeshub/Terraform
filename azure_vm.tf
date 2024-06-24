# Configuring the Azure provider

provider "azurerm" {
  subscription_id = "222b8490-d1d7-4ed8-9207-a74b220f3f9c"
  tenant_id = "61eaf031-7940-49a8-b751-674a401499f9"

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
