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
Error: Attribute redefined: The argument "aks_identity_id" was already set at modules/aks/locals.tf:22,3-18. Each argument may be set only once.

<!--- END_TF_DOCS --->