locals {
  name = "iac-terraform-ad-app"
  reply_urls = [
    "https://iac-terraform.com",
    "https://iac-terraform.com/.auth/login/aad/callback"
  ]
}

module "ad_application" {
  source = "../"

  resource_access_type = "Scope"
  ad_config = [
    {
      name       = local.name
      reply_urls = local.reply_urls
    }
  ]
  resource_api_id  = "00000003-0000-0000-c000-000000000000" // Microsoft Graph API
  resource_role_id = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" // User.Read API
}

resource "null_resource" "changed_reply_urls" {
  /* Orchestrates the destroy and create process of null_resource.auth dependencies
  /  during subsequent deployments that require new resources.
  */
  lifecycle {
    create_before_destroy = true
  }

  triggers = {
    app_service = join(",", local.reply_urls)
  }
  provisioner "local-exec" {
    environment = {
      URLS = join(" ", local.reply_urls)
      ID   = module.ad_application.azuread_config_data[local.name].application_id
    }

    command = <<EOF
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az account set --subscription $ARM_SUBSCRIPTION_ID
az ad app update --id "$ID" --reply-urls $URLS
az logout
EOF
  }
}
