output "url" {
  value       = "http://${azurerm_public_ip.vault.fqdn}:8200"
  description = "URL for Vault address"
}

output "public_dns_name" {
  value       = azurerm_public_ip.vault.fqdn
  description = "DNS for Vault server"
}

output "private_key" {
  value       = tls_private_key.vault.private_key_pem
  sensitive   = true
  description = "Private key to SSH into Vault server for debugging"
}