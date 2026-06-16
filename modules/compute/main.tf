resource "azurerm_public_ip" "vm_public_ip" {
  name                = "pip-${var.application_name}-${var.environment}-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "vm_nic" {
  name                = "nic-${var.application_name}-${var.environment}-vm"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "public"
    subnet_id                     = var.compute_subnet_id # Reference the subnet ID from the network module
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_public_ip.id
  }
}

# SSH key generation for VM access
resource "tls_private_key" "vm_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create the Linux virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm${var.application_name}${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B2s"
  admin_username      = "vmadmin"
  network_interface_ids = [
    azurerm_network_interface.vm_nic.id,
  ]

  admin_ssh_key {
    username   = "vmadmin"
    public_key = tls_private_key.vm_ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}