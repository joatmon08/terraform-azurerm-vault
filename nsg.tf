# Create Network Security Groups for subnets
resource "azurerm_network_security_group" "server_net" {
  name                = local.server_net_nsg
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create NSG associations
resource "azurerm_subnet_network_security_group_association" "server" {
  subnet_id                 = var.server_subnet_id
  network_security_group_id = azurerm_network_security_group.server_net.id
}

# Create Network Security Groups for NICs
# The associations are in the vm.tf file.
resource "azurerm_network_security_group" "server_nics" {
  name                = local.server_nic_nsg
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Create application security groups for servers, workers, and backend
# The associations are in the vm.tf file and remotehosts.tf file
resource "azurerm_application_security_group" "server_asg" {
  name                = local.server_asg
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Inbound rules for server subnet nsg
resource "azurerm_network_security_rule" "server_8200" {
  name                                       = "allow_8200"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "8200"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.server_asg.id]
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.server_net.name
}

resource "azurerm_network_security_rule" "server_ssh" {
  name                                       = "allow_ssh"
  priority                                   = 120
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.server_asg.id]
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.server_net.name
}

# Inbound rules for server nic nsg

resource "azurerm_network_security_rule" "server_nic_8200" {
  name                                       = "allow_8200"
  priority                                   = 100
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "8200"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.server_asg.id]
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.server_nics.name
}

resource "azurerm_network_security_rule" "server_nic_ssh" {
  name                                       = "allow_ssh"
  priority                                   = 120
  direction                                  = "Inbound"
  access                                     = "Allow"
  protocol                                   = "Tcp"
  source_port_range                          = "*"
  destination_port_range                     = "22"
  source_address_prefix                      = "*"
  destination_application_security_group_ids = [azurerm_application_security_group.server_asg.id]
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = azurerm_network_security_group.server_nics.name
}