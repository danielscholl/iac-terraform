variable "naming_rules" {
  description = "naming conventions yaml file"
  type        = string
}

# Mandatory tags (https://github.com/danielscholl/iac-terraform/modules/naming-rules)
variable "environment" {
  description = "rba.environment (https://github.com/Azure-Terraform/example-naming-template#customenvironment)"
  type        = string
}

variable "location" {
  description = "rba.azureRegion (https://github.com/Azure-Terraform/example-naming-template#customazureregion)"
  type        = string
}


# Optional tags
variable "product" {
  description = "rba.productGroup (https://github.com/iac-terraform/modules/naming-rules#customproductgroup) or [a-z0-9]{2,12}"
  type        = string
  default     = ""

  validation {
    condition     = length(regexall("[a-z0-9]{2,12}", var.product)) == 1
    error_message = "ERROR: product must [a-z0-9]{2,12}."
  }
}

# Optional free-form tags
variable "additional_tags" {
  type        = map(string)
  description = "A map of additional tags to add to the tags output"
  default     = {}
}
