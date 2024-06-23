# Demo file of creaing a resource group to deploy to Azure

# Provider block
provider "azurerm" {
  features {}
}

# Resource group block
resource "azurerm_resource_group" "resource_group" {
    name = "rg-teraform"
    location = "eastus"
}

# Example storage account
resource "azurerm_storage_account" "storage_account" {
  name = "terraform-homelab"
  resource_group_name = azurerm_resource_group.resource_group.name
  location = azurerm_resource_group.resource_group.location
  account_tier = "Basic"
  account_replication_type = "LRS"
}