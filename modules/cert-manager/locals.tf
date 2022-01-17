locals {
  delimiter = (var.name_identifier == "" ? "" : "-")
  le_endpoint = {
    "staging"    = "https://acme-staging-v02.api.letsencrypt.org/directory"
    "production" = "https://acme-v02.api.letsencrypt.org/directory"
  }
}
