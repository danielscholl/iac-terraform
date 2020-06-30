/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/

name                       = "simpleweb"
location                   = "eastus"
randomization_level        = 3
docker_registry_server_url = "mcr.microsoft.com"
deployment_targets = [{
  app_name                 = "app",
  image_name               = "azuredocs/aci-helloworld",
  image_release_tag_prefix = "latest"
}]
