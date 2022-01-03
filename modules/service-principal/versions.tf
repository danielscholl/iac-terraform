terraform {
  required_version = ">= 0.14.11"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.13.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.1.0"
    }
  }
}