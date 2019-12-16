/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/


name                    = "simpleweb"
location                = "eastus"
randomization_level     = 3

deployment_targets = [{
  app_name                 = "web",
  image_name               = "mcr.microsoft.com/azuredocs/aci-helloworld",
  image_release_tag_prefix = "latest"
}]
