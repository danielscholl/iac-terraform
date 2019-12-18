/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/

name                    = "webdata"
location                = "eastus"
randomization_level     = 8
cosmosdb_container_name = "user"
deployment_targets = [{
  app_name                 = "user",
  image_name               = "danielscholl/spring-user-api",
  image_release_tag_prefix = "latest"
}]
