# Create a public IP address for the load balancer
# The domain label is based on the resource group name
resource "azurerm_public_ip" "vault" {
  name                = local.pip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  domain_name_label   = "${var.resource_group_name}-vault"
  sku                 = "Standard"
  tags                = local.tags
}

# Create a load balancer for the workers and servers to use
resource "azurerm_lb" "vault" {
  name                = local.lb_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.vault.id
  }
  tags = local.tags
}

# Create two address pools for workers and servers
resource "azurerm_lb_backend_address_pool" "server" {
  loadbalancer_id = azurerm_lb.vault.id
  name            = "server"
}

# Associate all server NICs with the backend pool
resource "azurerm_network_interface_backend_address_pool_association" "server" {
  backend_address_pool_id = azurerm_lb_backend_address_pool.server.id
  ip_configuration_name   = "internal"
  network_interface_id    = azurerm_network_interface.server.id
}

# All health probe for server nodes
resource "azurerm_lb_probe" "server_8200" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.vault.id
  name                = "port-8200"
  port                = 8200
}

# Add LB rule for the servers
resource "azurerm_lb_rule" "server" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.vault.id
  name                           = "server"
  protocol                       = "Tcp"
  frontend_port                  = 8200
  backend_port                   = 8200
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.server_8200.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.server.id]
}

# Add an NAT rule for the server node using port 2022
# This is so you can SSH into the server to troubleshoot
# deployment issues.
resource "azurerm_lb_nat_rule" "server" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.vault.id
  name                           = "ssh-server"
  protocol                       = "Tcp"
  frontend_port                  = 2022
  backend_port                   = 22
  frontend_ip_configuration_name = "PublicIPAddress"
}

# Associate the NAT rule with the first server VM
resource "azurerm_network_interface_nat_rule_association" "server" {
  network_interface_id  = azurerm_network_interface.server.id
  ip_configuration_name = "internal"
  nat_rule_id           = azurerm_lb_nat_rule.server.id
}