/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/

name                    = "services"
location                = "centralus"
randomization_level     = 4
docker_registry_server_url = "mcr.microsoft.com"
deployment_targets = [{
  app_name                 = "api1"
  image_name               = "azuredocs/aci-helloworld",
  image_release_tag_prefix = "latest"
}]
