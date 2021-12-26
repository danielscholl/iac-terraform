provider "azuread" {

}


locals {
  name = "iac-osdu"
}

resource "random_id" "main" {
  keepers = {
    name = local.name
  }

  byte_length = 8
}


module "ad-application" {
  source = "../"

  name = format("${local.name}-%s-ad-app-management", random_id.main.hex)
  # aad_client_id = "10465c52-d094-4340-867d-c976ea1b1b14"

  reply_urls = [
    "https://iac-osdu.com/",
    "https://iac-osdu.com/.auth/login/aad/callback/"
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
      id          = "c672d818-eed1-44e4-9832-5dfbe6c1116f"
      name        = "test"
      description = "test"
      member_types = [
        "Application"
      ]
    }
  ]
}
