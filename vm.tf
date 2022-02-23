# Generate key pair for all VMs
resource "tls_private_key" "vault" {
  algorithm = "RSA"
  rsa_bits  = "2048"
}

# Create User Identities for server VMs and Worker VMs
# Could probably do this with a loop
resource "azurerm_user_assigned_identity" "server" {
  resource_group_name = var.resource_group_name
  location            = var.location

  name = local.server_user_id
  tags = local.tags
}

resource "azurerm_network_interface" "server" {
  name                = local.server_vm
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.server_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
  tags = local.tags
}

# Associate the network interfaces from the servers with the server NSG
resource "azurerm_network_interface_security_group_association" "server" {
  network_interface_id      = azurerm_network_interface.server.id
  network_security_group_id = azurerm_network_security_group.server_nics.id
}

# Associate the network interfaces from the servers with the server ASG for NSG rules
resource "azurerm_network_interface_application_security_group_association" "server" {
  network_interface_id          = azurerm_network_interface.server.id
  application_security_group_id = azurerm_application_security_group.server_asg.id
}

resource "azurerm_linux_virtual_machine" "server" {
  name                = local.server_vm
  location            = var.location
  resource_group_name = var.resource_group_name
  size                = var.server_vm_size
  admin_username      = "azureuser"
  computer_name       = "vault-server"
  network_interface_ids = [
    azurerm_network_interface.server.id,
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.vault.public_key_openssh
  }

  # Using Standard SSD tier storage
  # Accepting the standard disk size from image
  # No data disk is being used
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
  }

  #Source image is hardcoded b/c I said so
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.server.id]
  }

  custom_data = base64encode(
    templatefile("${path.module}/templates/vault.tmpl", {
      vault_version = var.vault_version
    })
  )

  tags = local.tags
}