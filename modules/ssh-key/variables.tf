##############################################################
# This module allows the creation of an SSH Key
##############################################################

variable "name" {
  type        = string
  default     = "id_rsa"
  description = "SSH key Name"
}

variable "ssh_public_key_path" {
  type        = string
  default     = "./ssh"
  description = "Path to SSH public key directory (e.g. `/secrets`)"
}

variable "ssh_key_algorithm" {
  type        = string
  default     = "RSA"
  description = "SSH key algorithm"
}

variable "private_key_extension" {
  type        = string
  default     = ""
  description = "Private key extension"
}

variable "public_key_extension" {
  type        = string
  default     = ".pub"
  description = "Public key extension"
}

variable "chmod_command" {
  type        = string
  default     = "chmod 600 %v"
  description = "Template of the command executed on the private key file"
}