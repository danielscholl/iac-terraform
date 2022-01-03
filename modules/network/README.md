# Module network

A terraform module that provisions networks with the following characteristics: 

- Vnet and Subnets with DNS Prefix


## Usage

```
module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}


module "network" {
  source     = "github.com/danielscholl/iac-terraform/modules/network"
  depends_on = [module.resource_group]

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name

  dns_servers = ["8.8.8.8"]
  address_space = ["10.0.1.0/24"]
  subnets = {
    Web-Tier = {
      cidrs = ["10.0.1.0/26"]

      allow_vnet_inbound      = true
      allow_vnet_outbound     = true
      allow_internet_outbound = true
    }
    App-Tier = {
      cidrs = ["10.0.1.64/26"]

      allow_vnet_inbound  = true
      allow_vnet_outbound = true
    }
    Data-Tier = {
      cidrs = ["10.0.1.128/26"]

      allow_vnet_inbound = true
    }
    Mgmt-Tier = {
      cidrs = ["10.0.1.192/27"]

      create_network_security_group = true
    }
    GatewaySubnet = {
      cidrs = ["10.0.1.224/28"]

      create_network_security_group = false
    }
  }

  # Tags
  resource_tags = {
    iac = "terraform"
  }
}
```

<!--- BEGIN_TF_DOCS --->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks_subnet"></a> [aks\_subnet](#module\_aks\_subnet) | ./subnet | n/a |
| <a name="module_subnet"></a> [subnet](#module\_subnet) | ./subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_route.aks_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route.non_inline_route](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route) | resource |
| [azurerm_route_table.aks_route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_route_table.route_table](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.aks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_subnet_route_table_association.association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_virtual_network_peering.peer](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_resource_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | CIDRs for virtual network | `list(string)` | n/a | yes |
| <a name="input_aks_subnets"></a> [aks\_subnets](#input\_aks\_subnets) | AKS subnets | <pre>map(object({<br>    private = any<br>    public  = any<br>    route_table = object({<br>      disable_bgp_route_propagation = bool<br>      routes                        = map(map(string))<br>      # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br>      # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br>    })<br>  }))</pre> | `null` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | If applicable, a list of custom DNS servers to use inside your virtual network.  Unset will use default Azure-provided resolver | `list(string)` | `null` | no |
| <a name="input_enforce_subnet_names"></a> [enforce\_subnet\_names](#input\_enforce\_subnet\_names) | enforce subnet names based on naming\_rules variable | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the vnet to create | `any` | `null` | no |
| <a name="input_names"></a> [names](#input\_names) | Names to be applied to resources (inclusive) | <pre>object({<br>    environment    = string<br>    location       = string<br>    product        = string<br>  })</pre> | <pre>{<br>  "environment": "sandbox",<br>  "location": "eastus2",<br>  "product": "iac"<br>}</pre> | no |
| <a name="input_naming_rules"></a> [naming\_rules](#input\_naming\_rules) | naming conventions yaml file | `string` | `""` | no |
| <a name="input_peer_defaults"></a> [peer\_defaults](#input\_peer\_defaults) | Maps of peer arguments. | <pre>object({<br>    id                           = string<br>    allow_virtual_network_access = bool<br>    allow_forwarded_traffic      = bool<br>    allow_gateway_transit        = bool<br>    use_remote_gateways          = bool<br>  })</pre> | <pre>{<br>  "allow_forwarded_traffic": false,<br>  "allow_gateway_transit": false,<br>  "allow_virtual_network_access": true,<br>  "id": null,<br>  "use_remote_gateways": false<br>}</pre> | no |
| <a name="input_peers"></a> [peers](#input\_peers) | Peer virtual networks.  Keys are names, allowed values are same as for peer\_defaults. Id value is required. | `any` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Default resource group name that the network will be created in. | `string` | `"myapp-rg"` | no |
| <a name="input_resource_tags"></a> [resource\_tags](#input\_resource\_tags) | Map of tags to apply to taggable resources in this module. By default the taggable resources are tagged with the name defined above and this map is merged in | `map(string)` | `{}` | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Maps of route tables | <pre>map(object({<br>    disable_bgp_route_propagation = bool<br>    use_inline_routes             = bool # Setting to true will revert any external route additions.<br>    routes                        = map(map(string))<br>    # keys are route names, value map is route properties (address_prefix, next_hop_type, next_hop_in_ip_address)<br>    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table#route<br>  }))</pre> | `{}` | no |
| <a name="input_subnet_defaults"></a> [subnet\_defaults](#input\_subnet\_defaults) | Maps of CIDRs, policies, endpoints and delegations | <pre>object({<br>    cidrs                                          = list(string)<br>    enforce_private_link_endpoint_network_policies = bool<br>    enforce_private_link_service_network_policies  = bool<br>    service_endpoints                              = list(string)<br>    delegations = map(object({<br>      name    = string<br>      actions = list(string)<br>    }))<br>    create_network_security_group = bool # create/associate network security group with subnet<br>    configure_nsg_rules           = bool # deny ingress/egress traffic and configure nsg rules based on below parameters<br>    allow_internet_outbound       = bool # allow outbound traffic to internet (configure_nsg_rules must be set to true)<br>    allow_lb_inbound              = bool # allow inbound traffic from Azure Load Balancer (configure_nsg_rules must be set to true)<br>    allow_vnet_inbound            = bool # allow all inbound from virtual network (configure_nsg_rules must be set to true)<br>    allow_vnet_outbound           = bool # allow all outbound from virtual network (configure_nsg_rules must be set to true)<br>    route_table_association       = string<br>  })</pre> | <pre>{<br>  "allow_internet_outbound": false,<br>  "allow_lb_inbound": false,<br>  "allow_vnet_inbound": false,<br>  "allow_vnet_outbound": false,<br>  "cidrs": [],<br>  "configure_nsg_rules": true,<br>  "create_network_security_group": true,<br>  "delegations": {},<br>  "enforce_private_link_endpoint_network_policies": false,<br>  "enforce_private_link_service_network_policies": false,<br>  "route_table_association": null,<br>  "service_endpoints": []<br>}</pre> | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Map of subnets. Keys are subnet names, Allowed values are the same as for subnet\_defaults | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aks"></a> [aks](#output\_aks) | Virtual network information matching AKS module input. |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Maps of custom route tables. |
| <a name="output_subnet"></a> [subnet](#output\_subnet) | Map of subnet data objects. |
| <a name="output_subnet_nsg_ids"></a> [subnet\_nsg\_ids](#output\_subnet\_nsg\_ids) | Map of subnet ids to associated network\_security\_group ids. |
| <a name="output_subnet_nsg_names"></a> [subnet\_nsg\_names](#output\_subnet\_nsg\_names) | Map of subnet names to associated network\_security\_group names. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | Maps of subnet info. |
| <a name="output_vnet"></a> [vnet](#output\_vnet) | Virtual network data object. |

<!--- END_TF_DOCS --->