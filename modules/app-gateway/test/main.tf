module "resource_group" {
  source = "github.com/danielscholl/iac-terraform/modules/resource-group"

  name     = "iac-terraform"
  location = "eastus2"
}


module "network" {
    source = "../../network"

    name                = "iac-terraform-vnet-${module.resource_group.random}"
    resource_group_name = module.resource_group.name
    address_space       = "10.0.1.0/24"
    dns_servers         = ["8.8.8.8"]
    subnet_prefixes     = ["10.0.1.0/26", "10.0.1.224/28"]
    subnet_names        = ["Web-Tier", "GatewaySubnet"]

    # Tags
    resource_tags = {
      iac = "terraform"
    }
}

module "appgateway" {
  source                                    = "../"

  name                                      = "iac-terraform-gw-${module.resource_group.random}"
  resource_group_name                       = module.resource_group.name
  location                                  = module.resource_group.location
  vnet_name                                 = module.network.name
  subnet_name                               = module.network.subnet_names[0]
  appgateway_ipconfig_name                  = "iac-terraform-ipconfig" 
  appgateway_frontend_port_name             = "iac-terraform-frontend-port"
  appgateway_frontend_ip_configuration_name = "iac-terraform-frontend-ipconfig"
  appgateway_backend_address_pool_name      = "iac-terraform-backend-address-pool"
  appgateway_backend_http_setting_name      = "iac-terraform-backend-http-setting"
  appgateway_listener_name                  = "iac-terraform-appgateway-listener"
  appgateway_request_routing_rule_name      = "iac-terraform-appgateway-request-routing-rule"
}