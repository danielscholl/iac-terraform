# Module ad-application

Module for managing an Azure Active Directory Application with the following characteristics:

- Create an application and optionally assign roles to it..

> __This module requires the Terraform Principal to have Azure Active Directory Graph - `Application.ReadWrite.OwnedBy` Permissions.__


## Usage

```
module "ad_application" {
    source = "github.com/danielscholl/iac-terraform/modules/ad-application"

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
```

## Inputs

| Variable Name | Type       | Description                          | 
| ------------- | ---------- | ------------------------------------ |
| `name`        | _string_   | The name of the application.         |
| `type`        | _string_   | Type of the application. Default: `webapp/api` |
| `homepage`    | _string_   | The URL to the application's home page. Default:  `null` |
| `oauth2_allow_implicit_flow` | _bool_ | Does this ad application allow oauth2 implicit flow tokens? |
| `available_to_other_tenants` | _bool_ | Is this ad application available to other tenants? |
| `group_membership_claims` | _bool_ | Configures the groups claim issued in a user or OAuth 2.0 access token that the app expects. Default: `SecurityGroup` |
| `identifier_uris` | _string_ | A list of user-defined URI(s) that uniquely identify a Web application within it's Azure AD tenant Default: `null`.
| `reply_urls`  | _list_     | A list of URLs that user tokens are sent to for sign in, or the redirect URIs that OAuth 2.0 authorization codes and access tokens are sent to. Default: `[]` |
| `required_resource_access` | _object_ | Required resource access for this application. Default: `[]` |



## Outputs

Once the deployments are completed successfully, the output for the current module will be in the format mentioned below:

- `name`: The name of the application.
- `id`: The name of the application.



