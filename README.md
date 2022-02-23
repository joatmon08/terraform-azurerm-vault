# terraform-azurerm-vault

A Terraform module to deploy a Vault server on Azure for testing and exploration.
It uses the latest release of
[HashiCorp Vault](https://www.vaultproject.io/) available for Linux.

For the exact configuration, review the server configuration under
`templates/`.

**NOTE:** Use this module for testing purposes only! TLS is disabled.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.18.0 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.97.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_application_security_group.server_asg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_security_group) | resource |
| [azurerm_lb.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb) | resource |
| [azurerm_lb_backend_address_pool.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool) | resource |
| [azurerm_lb_nat_rule.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule) | resource |
| [azurerm_lb_probe.server_8200](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_probe) | resource |
| [azurerm_lb_rule.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule) | resource |
| [azurerm_linux_virtual_machine.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_security_group_association.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_security_group_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_nat_rule_association.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_nat_rule_association) | resource |
| [azurerm_network_interface_security_group_association.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_network_security_group.server_net](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.server_nics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.server_8200](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.server_nic_8200](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.server_nic_ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.server_ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_public_ip.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet_network_security_group_association.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [random_id.id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.vault](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | Location of Azure resource group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of Azure resource group. | `string` | n/a | yes |
| <a name="input_server_subnet_id"></a> [server\_subnet\_id](#input\_server\_subnet\_id) | Azure subnet ID for Vault server. | `string` | n/a | yes |
| <a name="input_server_vm_size"></a> [server\_vm\_size](#input\_server\_vm\_size) | Size of server VM for Vault. Default is `Standard_D2as_v4`. | `string` | `"Standard_D2as_v4"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to add to Boundary resources. Merged with module tags. | `map(string)` | `{}` | no |
| <a name="input_vault_version"></a> [vault\_version](#input\_vault\_version) | Version of Vault to install. Default is `1.9.3`. | `string` | `"1.9.3"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_key"></a> [private\_key](#output\_private\_key) | Private key to SSH into Vault server for debugging |
| <a name="output_public_dns_name"></a> [public\_dns\_name](#output\_public\_dns\_name) | DNS for Vault server |
| <a name="output_url"></a> [url](#output\_url) | URL for Vault address |
