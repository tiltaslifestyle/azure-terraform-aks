resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "aks" {
  name                 = "snet-${var.application_name}-${var.environment}-aks"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = var.aks_subnet_cidr
}

resource "azurerm_subnet" "compute" {
  name                 = "snet-${var.application_name}-${var.environment}-compute"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.26.2.0/24"]
}

resource "azurerm_network_security_group" "vm_nsg" {
  name                = "nsg-${var.application_name}-${var.environment}-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowSSHInbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "compute_nsg_assoc" {
  subnet_id                 = azurerm_subnet.compute.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}