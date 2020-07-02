##############################################################
# This module allows the creation of an SSH Key
##############################################################

output "key_name" {
  value       = var.name
  description = "Name of SSH key"
}

output "public_key" {
  value       = join("", tls_private_key.default.*.public_key_openssh)
  description = "Content of the generated public key"
}

output "private_key" {
  value       = join("", tls_private_key.default.*.private_key_pem) 
  sensitive   = true    
}
