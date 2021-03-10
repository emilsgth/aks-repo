# ------- Networking -----------

# Virtual Network
resource "azurerm_virtual_network" "aks" {
  name                = var.azurerm_virtual_network_name
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["10.30.0.0/16"]
  location            = var.location
}

# Subnet
resource "azurerm_subnet" "aks" {
  name                 = var.azurerm_subnet_name
  virtual_network_name = azurerm_virtual_network.aks.name
  resource_group_name = azurerm_resource_group.aks.name
  address_prefixes       = ["10.30.1.0/24"]
}

