##############################################################
# This module allows the creation of a service-principal
##############################################################

variable "name" {
  type        = string
  description = "The name of the service principal."
}

variable "password" {
  type        = string
  description = "A password for the service principal. (Optional)"
  default     = ""
}

variable "end_date" {
  type        = string
  description = "The relative duration or RFC3339 date after which the password expire."
  default     = "2Y"
}

variable "role" {
  type        = string
  description = "The name of a role for the service principal."
  default     = ""
}

variable "scopes" {
  type        = list(string)
  description = "List of scopes the role assignment applies to."
  default     = []
}

locals {
  scopes = length(var.scopes) > 0 ? var.scopes : [data.azurerm_subscription.main.id]

  date = regexall("^(?:(\\d{4})-(\\d{2})-(\\d{2}))[Tt]?(?:(\\d{2}):(\\d{2})(?::(\\d{2}))?(?:\\.(\\d+))?)?([Zz]|[\\+|\\-]\\d{2}:\\d{2})?$", var.end_date)

  duration = regexall("^(?:(\\d+)Y)?(?:(\\d+)M)?(?:(\\d+)W)?(?:(\\d+)D)?(?:(\\d+)h)?(?:(\\d+)m)?(?:(\\d+)s)?$", var.end_date)

  end_date_relative = length(local.duration) > 0 ? format(
    "%dh",
    (
      (coalesce(local.duration[0][0], 0) * 24 * 365) +
      (coalesce(local.duration[0][1], 0) * 24 * 30) +
      (coalesce(local.duration[0][2], 0) * 24 * 7) +
      (coalesce(local.duration[0][3], 0) * 24) +
      coalesce(local.duration[0][4], 0)
    )
  ) : null

  end_date = length(local.date) > 0 ? format(
    "%02d-%02d-%02dT%02d:%02d:%02d.%02d%s",
    local.date[0][0],
    local.date[0][1],
    local.date[0][2],
    coalesce(local.date[0][3], "23"),
    coalesce(local.date[0][4], "59"),
    coalesce(local.date[0][5], "00"),
    coalesce(local.date[0][6], "00"),
    coalesce(local.date[0][7], "Z")
  ) : null
}