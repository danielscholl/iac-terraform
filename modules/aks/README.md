# Module network

A terraform module that provisions kubernetes clusters with the following characteristics: 

- Node Pools
- AddOns
- Identity
- Encryption
- RBAC


## Usage

```
resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "null_resource" "save-key" {
  triggers = {
    key = tls_private_key.key.private_key_pem
  }

  provisioner "local-exec" {
    command = <<EOF
      mkdir -p ${path.module}/.ssh
      echo "${tls_private_key.key.private_key_pem}" > ${path.module}/.ssh/id_rsa
      chmod 0600 ${path.module}/.ssh/id_rsa
    EOF
  }
}

module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}


module "aks" {
  source     = "github.com/danielscholl/iac-terraform/modules/aks"
  depends_on = [module.resource_group]

  name                = format("iac-terraform-cluster-%s", module.resource_group.random)
  resource_group_name = module.resource_group.name
  dns_prefix          = format("iac-terraform-cluster-%s", module.resource_group.random)

  linux_profile = {
    admin_username = "k8sadmin"
    ssh_key        = "${trimspace(tls_private_key.key.public_key_openssh)} k8sadmin"
  }

  default_node_pool = "default"
  node_pools = {
    default = {
      vm_size                = "Standard_B2s"
      enable_host_encryption = true

      node_count = 3
    }
  }

  resource_tags = {
    iac = "terraform"
  }
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.7 |
| azurerm | >= 2.90.0 |
| http | >= 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.90.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acr\_pull\_access | map of ACR ids to allow AcrPull | `map(string)` | `{}` | no |
| api\_server\_authorized\_ip\_ranges | authorized IP ranges to communicate with K8s API | `map(string)` | `null` | no |
| configure\_network\_role | Add Network Contributor role for identity on input subnets. | `bool` | `true` | no |
| default\_node\_pool | Default node pool.  Value refers to key within node\_pools variable. | `string` | `"default"` | no |
| dns\_prefix | DNS prefix specified when creating the managed cluster. | `string` | `null` | no |
| enable\_http\_application\_routing | Enable HTTP Application Routing Addon (forces recreation). | `bool` | `false` | no |
| enable\_keyvault\_secrets | (Optional) Enable Keyvault CSI Driver | `bool` | `false` | no |
| enable\_monitoring | (Optional) Enable Monitoring | `bool` | `false` | no |
| enable\_policy | Enable Azure Policy Addon. | `bool` | `false` | no |
| enable\_private\_cluster | If true cluster API server will be exposed only on internal IP address and available only in cluster vnet. | `bool` | `false` | no |
| identity\_type | SystemAssigned or UserAssigned. | `string` | `"SystemAssigned"` | no |
| kubernetes\_version | Kubernetes Version (Default) - latest | `string` | `null` | no |
| linux\_profile | linux profile admin user/key | <pre>object({<br>    admin_username = string<br>    ssh_key        = string<br>  })</pre> | `null` | no |
| log\_analytics\_workspace\_id | ID of the Azure Log Analytics Workspace | `string` | `null` | no |
| name | The name of the Kubernetes Cluster. (Optional) - names override | `string` | `null` | no |
| names | Names to be applied to resources (inclusive) | <pre>object({<br>    environment    = string<br>    location       = string<br>    product        = string<br>  })</pre> | <pre>{<br>  "environment": "tf",<br>  "location": "eastus2",<br>  "product": "iac"<br>}</pre> | no |
| network\_plugin | network plugin to use for networking (azure or kubenet) | `string` | `"kubenet"` | no |
| network\_policy | Sets up network policy to be used with Azure CNI. | `string` | `null` | no |
| network\_profile\_options | docker\_bridge\_cidr, dns\_service\_ip and service\_cidr should all be empty or all should be set | <pre>object({<br>    docker_bridge_cidr = string<br>    dns_service_ip     = string<br>    service_cidr       = string<br>  })</pre> | `null` | no |
| node\_pool\_defaults | node pool defaults | <pre>object({<br>    vm_size                      = string<br>    availability_zones           = list(number)<br>    node_count                   = number<br>    enable_auto_scaling          = bool<br>    min_count                    = number<br>    max_count                    = number<br>    enable_host_encryption       = bool<br>    enable_node_public_ip        = bool<br>    max_pods                     = number<br>    node_labels                  = map(string)<br>    only_critical_addons_enabled = bool<br>    orchestrator_version         = string<br>    os_disk_size_gb              = number<br>    os_disk_type                 = string<br>    type                         = string<br>    tags                         = map(string)<br>    subnet                       = string # must be key from node_pool_subnets variable<br><br>    # settings below not available in default node pools<br>    mode                         = string<br>    node_taints                  = list(string)<br>    max_surge                    = string<br>    eviction_policy              = string<br>    os_type                      = string<br>    priority                     = string<br>    proximity_placement_group_id = string<br>    spot_max_price               = number<br>  })</pre> | <pre>{<br>  "availability_zones": [<br>    1,<br>    2,<br>    3<br>  ],<br>  "enable_auto_scaling": false,<br>  "enable_host_encryption": false,<br>  "enable_node_public_ip": false,<br>  "eviction_policy": null,<br>  "max_count": null,<br>  "max_pods": null,<br>  "max_surge": "1",<br>  "min_count": null,<br>  "mode": "User",<br>  "name": null,<br>  "node_count": 1,<br>  "node_labels": null,<br>  "node_taints": null,<br>  "only_critical_addons_enabled": false,<br>  "orchestrator_version": null,<br>  "os_disk_size_gb": null,<br>  "os_disk_type": "Managed",<br>  "os_type": "Linux",<br>  "priority": "Regular",<br>  "proximity_placement_group_id": null,<br>  "spot_max_price": null,<br>  "subnet": null,<br>  "tags": null,<br>  "type": "VirtualMachineScaleSets",<br>  "vm_size": "Standard_B2s"<br>}</pre> | no |
| node\_pools | node pools | `any` | <pre>{<br>  "default": {}<br>}</pre> | no |
| node\_resource\_group | The name of the Resource Group where the Kubernetes Nodes should exist. | `string` | `null` | no |
| outbound\_type | outbound (egress) routing method which should be used for this Kubernetes Cluster | `string` | `"loadBalancer"` | no |
| pod\_cidr | used for pod IP addresses | `string` | `null` | no |
| rbac | role based access control settings | <pre>object({<br>    enabled        = bool<br>    ad_integration = bool<br>  })</pre> | <pre>{<br>  "ad_integration": false,<br>  "enabled": true<br>}</pre> | no |
| rbac\_admin\_object\_ids | Admin group object ids for use with rbac active directory integration | `map(string)` | `{}` | no |
| resource\_group\_name | The name of an existing resource group. | `string` | n/a | yes |
| resource\_tags | Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in | `map(string)` | `{}` | no |
| sku\_tier | Sets the cluster's SKU tier. The paid tier has a financially-backed uptime SLA. Read doc [here](https://docs.microsoft.com/en-us/azure/aks/uptime-sla). | `string` | `"Free"` | no |
| user\_assigned\_identity | User assigned identity for the manged cluster (leave and the module will create one). | <pre>object({<br>    id           = string<br>    principal_id = string<br>    client_id    = string<br>  })</pre> | `null` | no |
| user\_assigned\_identity\_name | Name of user assigned identity to be created (if applicable). | `string` | `null` | no |
| virtual\_network | Virtual network info. | <pre>object({<br>    subnets = map(object({<br>      id = string<br>    }))<br>    route_table_id = string<br>  })</pre> | `null` | no |
| windows\_profile | windows profile admin user/pass | <pre>object({<br>    admin_username = string<br>    admin_password = string<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| aks\_egress\_ip\_address | n/a |
| client\_certificate | kubernetes client certificate |
| client\_key | kubernetes client key |
| cluster\_ca\_certificate | kubernetes cluster ca certificate |
| effective\_outbound\_ips\_ids | The outcome (resource IDs) of the specified arguments. |
| host | kubernetes host |
| id | n/a |
| kube\_config | kubernetes config to be used by kubectl and other compatible tools |
| kube\_config\_raw | raw kubernetes config to be used by kubectl and other compatible tools |
| kubelet\_identity | kubelet identity information |
| location | n/a |
| name | kubernetes managed cluster name |
| node\_resource\_group | auto-generated resource group which contains the resources for this managed kubernetes cluster |
| password | kubernetes password |
| principal\_id | id of the principal used by this managed kubernetes cluster |
| username | kubernetes username |

<!--- END_TF_DOCS --->