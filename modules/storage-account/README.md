# Module storage-account

A terraform module that provisions and scales an storage account with the following characteristics: 

- Ability to enrolls storage account into azure 'managed identities' authentication.
- Create multiple containers with access levels.


## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}

module "storage_account" {
  source                    = "github.com/danielscholl/iac-terraform/modules/storage-account"
  resource_group_name       = module.resource_group.name
  name                      = substr("iacterraform${module.resource_group.random}", 0, 23)
  containers = [
    {
      name  = "iac-container",
      access_type = "private"
    }
  ]
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.11 |
| azurerm | >= 2.90.0 |
| random | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.90.0 |
| random | >= 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_list | Map of CIDRs Storage Account access. | `map(string)` | `{}` | no |
| access\_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts | `string` | `"Hot"` | no |
| account\_kind | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | `"StorageV2"` | no |
| account\_tier | Defines the Tier to use for this storage account (Standard or Premium). | `string` | `null` | no |
| allow\_blob\_public\_access | Allow or disallow public access to all blobs or containers in the storage account. | `bool` | `false` | no |
| assign\_identity | Set to `true` to enable system-assigned managed identity, or `false` to disable it. | `bool` | `true` | no |
| blob\_cors | blob service cors rules:  https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#cors_rule | <pre>map(object({<br>    allowed_headers    = list(string)<br>    allowed_methods    = list(string)<br>    allowed_origins    = list(string)<br>    exposed_headers    = list(string)<br>    max_age_in_seconds = number<br>  }))</pre> | `null` | no |
| blob\_delete\_retention\_days | Retention days for deleted blob. Valid value is between 1 and 365 (set to 0 to disable). | `number` | `7` | no |
| containers | List of storage containers. | <pre>list(object({<br>    name        = string<br>    access_type = string<br>  }))</pre> | `[]` | no |
| custom\_404\_path | path from your repo root to your custom 404 page | `string` | `null` | no |
| default\_network\_rule | Specifies the default action of allow or deny when no other network rules match | `string` | `"Deny"` | no |
| enable\_hns | Enable Hierarchical Namespace (can be used with Azure Data Lake Storage Gen 2). | `bool` | `false` | no |
| enable\_https\_traffic\_only | Forces HTTPS if enabled. | `bool` | `true` | no |
| enable\_large\_file\_share | Enable Large File Share. | `bool` | `false` | no |
| enable\_static\_website | Controls if static website to be enabled on the storage account. Possible values are `true` or `false` | `bool` | `false` | no |
| encryption\_scopes | Encryption scopes, keys are scope names. more info https://docs.microsoft.com/en-us/azure/storage/common/infrastructure-encryption-enable?tabs=portal | <pre>map(object({<br>    enable_infrastructure_encryption = bool<br>  }))</pre> | `{}` | no |
| ensure\_https | Boolean flag which forces HTTPS in order to ensure secure connections. | `bool` | `true` | no |
| index\_path | path from your repo root to index.html | `string` | `null` | no |
| min\_tls\_version | The minimum supported TLS version for the storage account. | `string` | `"TLS1_2"` | no |
| name | The name of the Storage Account. (Optional) - names override | `string` | `null` | no |
| names | Names to be applied to resources (inclusive) | <pre>object({<br>    environment    = string<br>    location       = string<br>    product        = string<br>  })</pre> | <pre>{<br>  "environment": "tf",<br>  "location": "eastus2",<br>  "product": "iac"<br>}</pre> | no |
| nfsv3\_enabled | Is NFSv3 protocol enabled? Changing this forces a new resource to be created | `bool` | `false` | no |
| replication\_type | Storage account replication type - i.e. LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS. | `string` | `"LRS"` | no |
| resource\_group\_name | The name of an existing resource group. | `string` | n/a | yes |
| resource\_tags | Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in | `map(string)` | `{}` | no |
| service\_endpoints | Creates a virtual network rule in the subnet\_id (values are virtual network subnet ids). | `map(string)` | `{}` | no |
| shared\_access\_key\_enabled | Indicates whether the storage account permits requests to be authorized with the account access key via Shared Key | `bool` | `false` | no |
| traffic\_bypass | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. | `list(string)` | <pre>[<br>  "None"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| containers | Map of containers. |
| id | The storage account Id. |
| managed\_identities\_id | The principal ID generated from enabling a Managed Identity with this storage account. |
| name | The name of the storage account. |
| primary\_access\_key | The primary access key for the storage account. |
| primary\_connection\_string | The primary connection string for the storage account. |
| tenant\_id | The tenant ID for the Service Principal of this storage account. |

<!--- END_TF_DOCS --->