# Azure - Delegated DNS Zone

## Introduction

This module will create a Delegated DNS Zone in an existing DNS zone in Azure. 
* The Terraform credentials being used must have access to both the child and parent subsciptions (they may be the same).
* child_domain_prefix may include multiple subdomains
  - child.domain.prefix.parent.domain

## Usage

```
module "dns" {
  source = "github.com/danielscholl/iac-terraform.git/modules/dns-zone"

  child_domain_resource_group_name = "child-domain-resource-group"
  child_domain_subscription_id     = "00000-0000-0000-0000-0000000"
  child_domain_prefix              = "prod.west"

  parent_domain_resource_group_name = "parent-domain-resource-group"
  parent_domain_subscription_id     = "11111-1111-1111-1111-111111"
  parent_domain                     = "example.com"

  tags = { "environment" = "production"
           "location"    = "west" }
}

output "domain" {
  value = module.dns.name
}
```

<!--- BEGIN_TF_DOCS --->

<!--- END_TF_DOCS --->