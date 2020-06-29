provider "azuread" {

}


module "ad-application" {
  source = "../"

  name                    = "iac-terraform-ad-app"
  group_membership_claims = "All"

  reply_urls = [
    "https://iac-terraform.com",
    "https://iac-terraform.com/.auth/login/aad/callback"
  ]

  api_permissions = [
    {
      name = "Microsoft Graph"
      oauth2_permissions = [
        "Directory.Read.All",
        "User.Read"
      ]
      app_roles = [
        "Directory.Read.All"
      ]
    }
  ]

  app_roles = [
    {
      name        = "test"
      description = "test"
      member_types = [
        "Application"
      ]
    }
  ]
}

# resource "null_resource" "changed_reply_urls" {
#   /* Orchestrates the destroy and create process of null_resource.auth dependencies
#   /  during subsequent deployments that require new resources.
#   */
#   lifecycle {
#     create_before_destroy = true
#   }

#   triggers = {
#     app_service = join(",", local.reply_urls)
#   }
#   provisioner "local-exec" {
#     environment = {
#       URLS = join(" ", local.reply_urls)
#       ID   = module.ad_application.azuread_config_data[local.name].application_id
#     }

#     command = <<EOF
# az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
# az account set --subscription $ARM_SUBSCRIPTION_ID
# az ad app update --id "$ID" --reply-urls $URLS
# az logout
# EOF
#   }
# }