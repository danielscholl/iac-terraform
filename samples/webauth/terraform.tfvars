/*
.Synopsis
   Terraform Variable File
.DESCRIPTION
   This file holds the variables to be used with the application.
*/

name                       = "webauth"
location                   = "centralus"
randomization_level        = 4
lock                       = false
docker_registry_server_url = "docker.io"
web_apps = [{
  app_name                 = "web"
  image_name               = "danielscholl/spring-user-api",
  image_release_tag_prefix = "latest"
}]
