##############################################################
# This module allows the creation of a Resource Group
##############################################################

variable "name" {
  description = "The name of the Resource Group"
  type    = string
}

variable "location" {
  description = "The location of the Resource Group"
  type    = string
}

variable "environment" {
  description = "The environment tag for the Resource Group"
  type    = string
  default = "dev"
}
