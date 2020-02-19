# Module ad-application

Module for managing an Azure Active Directory Application with the following characteristics:

- Create an application and optionally assign roles to it..

> __This module requires the Terraform Principal to have Azure Active Directory Graph - `Application.ReadWrite.OwnedBy` Permissions.__


## Usage

```
module "ad-application" {
  source = "github.com/danielscholl/iac-terraform/modules/ad-application"

  name = "iac-terraform-ad-app"
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
```

## Inputs

| Variable Name | Type       | Description                          | 
| ------------- | ---------- | ------------------------------------ |
| `name`        | _string_   | The name of the application.         |
| `homepage`    | _string_   | The URL of the application's homepage. |
| `reply_urls`  | _list_     | A list of URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to. Default: `[]` |
| `identifier_uris` | _string_ | A list of user-defined URI(s) that uniquely identify a Web application within it's Azure AD tenant Default: `null`. |
| `oauth2_allow_implicit_flow` | _bool_ | Does this ad application allow oauth2 implicit flow tokens? |
| `available_to_other_tenants` | _bool_ | Is this ad application available to other tenants? |
| `group_membership_claims` | _bool_ | Configures the groups claim issued in a user or OAuth 2.0 access token that the app expects. Default: `SecurityGroup` |
| `password` | _string_ | The application password (aka client secret). If empty, Terraform will generate a password. |
| `end_date` | _string_ | The date after which the password expire. This can either be relative duration or RFC3339 date. Default: `1Y`. |
| `api_permissions` | _list_ | List of API permissions. |
| `app_roles` | _list_ | List of App roles. |



## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `name`: The name of the application.
- `id`: The name of the application.
- `object_id`:  The object ID of the application.
- `roles`:  The application roles.
- `password`:  The password for the application.