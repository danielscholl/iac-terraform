
module "ad_application" {
    source = "../"

    name = "iac-terraform-ad-app"
    reply_urls = [
      "https://iac-terraform.com",
      "https://iac-terraform.com/.auth/login/aad/callback"
    ]
    required_resource_access = [
      {
        resource_app_id = "00000002-0000-0000-c000-000000000000" // ID for Windows Graph API
        resource_access = [
          {
            id = "824c81eb-e3f8-4ee6-8f6d-de7f50d565b7", // ID for Application.ReadWrite.OwnedBy
            type = "Role"
          }
        ]
      }
    ]
}