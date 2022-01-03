# Module ad-application

Module for managing an Azure Active Directory Application with the following characteristics:

- Create an application and optionally assign roles to it..

> __This module requires the Terraform Principal to have Azure Active Directory Graph - `Application.ReadWrite.OwnedBy` Permissions.__


## Usage

```
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
  source = "github.com/danielscholl/iac-terraform/modules/ad-application"

  name = format("${local.name}-%s-ad-app-management", random_id.main.hex)

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
```


<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.11 |
| azuread | >= 2.13.0 |
| random | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | >= 2.13.0 |
| random | 3.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_client\_id | Existing Application AppId. | `string` | `""` | no |
| api\_permissions | List of API permissions. | `any` | `[]` | no |
| app\_roles | List of App roles. | `any` | `[]` | no |
| end\_date | The RFC3339 date after which credentials expire. | `string` | `"2Y"` | no |
| group\_membership\_claims | Configures the groups claim issued in a user or OAuth 2.0 access token that the app expects. | `list(string)` | <pre>[<br>  "All"<br>]</pre> | no |
| homepage | The URL of the application's homepage. | `string` | `""` | no |
| identifier\_uris | List of unique URIs that Azure AD can use for the application. | `list(string)` | `[]` | no |
| name | The display name of the application | `string` | n/a | yes |
| native | Whether the application can be installed on a user's device or computer. | `bool` | `false` | no |
| oauth2\_allow\_implicit\_flow | Whether to allow implicit grant flow for OAuth2. | `bool` | `false` | no |
| password | The application password (aka client secret). | `string` | `""` | no |
| reply\_urls | List of URIs to which Azure AD will redirect in response to an OAuth 2.0 request. | `list(string)` | `[]` | no |
| sign\_in\_audience | Whether the application can be used from any Azure AD tenants. | `string` | `"AzureADMyOrg"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the application. |
| name | The display name of the application. |
| object\_id | The object ID of the application. |
| password | The password for the application. |
| roles | The application roles. |

<!--- END_TF_DOCS --->