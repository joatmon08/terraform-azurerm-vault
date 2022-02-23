variable "resource_group_name" {
  type        = string
  description = "Name of Azure resource group."
}

variable "location" {
  type        = string
  description = "Location of Azure resource group."
}

variable "server_subnet_id" {
  type        = string
  description = "Azure subnet ID for Vault server."
}

variable "server_vm_size" {
  type        = string
  default     = "Standard_D2as_v4"
  description = "Size of server VM for Vault. Default is `Standard_D2as_v4`."
}

variable "vault_version" {
  type        = string
  default     = "1.9.3"
  description = "Version of Vault to install. Default is `1.9.3`."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "List of tags to add to Boundary resources. Merged with module tags."
}

data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

resource "random_id" "id" {
  byte_length = 8
}

locals {
  tags = merge({
    module = "joatmon08/terraform-azurerm-vault"
  }, var.tags)

  server_net_nsg = "server-net-${random_id.id.hex}"
  server_nic_nsg = "server-nic-${random_id.id.hex}"
  server_asg     = "server-asg-${random_id.id.hex}"
  server_vm      = "server-${random_id.id.hex}"
  server_user_id = "server-userid-${random_id.id.hex}"

  pip_name = "vault-${random_id.id.hex}"
  lb_name  = "vault-${random_id.id.hex}"

  pg_name = "vault-${random_id.id.hex}"

  sp_name = "vault-${random_id.id.hex}"
}
