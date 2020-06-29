provider "azurerm" {
  features {}
}

module "resource_group" {
  source   = "../../resource-group"
  name     = "iac-terraform"
  location = "eastus2"
}

module "network" {
  source = "../../network"

  name                = "iac-terraform-vnet"
  resource_group_name = module.resource_group.name
  address_space       = "10.10.0.0/16"
  dns_servers         = ["8.8.8.8"]
  subnet_prefixes     = ["10.10.1.0/24"]
  subnet_names        = ["vm-subnet"]
}

# module "windows10desktop" {
#   source = "../"

#   resource_group_name = module.resource_group.name
#   vm_hostname         = "desktop-vm"
#   vm_os_simple        = "Windows10"
#   vm_size             = "Standard_D4s_v3"
#   public_ip_dns       = ["windesktopvmips"]
#   vnet_subnet_id      = module.network.subnets.0
#   admin_password      = "AzurePassword@123"
#   custom_script       = "https://gist.githubusercontent.com/danielscholl/d98b3c1d301b1bb234b6566bf2bedf1f/raw/c974d972adac2eff098d3cd757de4427fa4d2a9b/bootstrap.ps1"
# }

module "WindowsServer" {
  source = "../"

  resource_group_name = module.resource_group.name
  vm_hostname         = "server-vm"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["winservervmips"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.subnets.0
  admin_password      = "AzurePassword@123"
}

module "LinuxServer" {
  source = "../"

  resource_group_name = module.resource_group.name
  vm_hostname         = "linux-vm"
  vm_os_simple        = "UbuntuServer"
  vm_instances        = 2
  public_ip_dns       = ["iacterraformvm0"]
  vnet_subnet_id      = module.network.subnets.0
  admin_password      = "AzurePassword@123"
}