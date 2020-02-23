module "resource_group" {
  source   = "github.com/danielscholl/iac-terraform/modules/resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "network" {
  source = "github.com/danielscholl/iac-terraform/modules/network"

  name                = "iac-terraform-vnet-${module.resource_group.random}"
  resource_group_name = module.resource_group.name
  address_space       = "10.10.0.0/16"
  dns_servers         = ["8.8.8.8"]
  subnet_prefixes     = ["10.10.1.0/24"]
  subnet_names        = ["vm-subnet"]
}

module "linuxservers" {
  source         = "github.com/danielscholl/iac-terraform/modules/virtual-machine"
  vm_hostname    = "myVM"
  vm_os_simple   = "UbuntuServer"
  public_ip_dns  = ["linsimplevmips"] // change to a unique name per datacenter region
  vnet_subnet_id = module.network.subnets.0
}