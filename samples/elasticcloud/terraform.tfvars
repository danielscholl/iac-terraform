/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/

name                = "elasticcloud"
location            = "eastus"
randomization_level = 3

elasticsearch = {
   dev-elastic = {
      agent_pool   = "dev"
      node_count   = 3
      cpu = 2
      memory = 8
      storage = 128
   }
   stg-elastic = {
      agent_pool   = "stg"
      node_count   = 3
      cpu = 2
      memory = 8
      storage = 128
   }
   prd-elastic = {
      agent_pool   = "prod"
      node_count   = 3
      cpu = 2
      memory = 8
      storage = 128
   }
}