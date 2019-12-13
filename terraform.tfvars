# Note to developers: This file shows some examples that you may
# want to use in order to configure this template. It is your
# responsibility to choose the values that make sense for your application.
#
# Note: These values will impact the names of resources. If your deployment
# fails due to a resource name collision, consider using different values for
# the `name` variable or increasing the value for `randomization_level`.

resource_group_location = "eastus"
name                    = "user"
randomization_level     = 3

deployment_targets = [{
  app_name                 = "web",
  image_name               = "mcr.microsoft.com/azuredocs/aci-helloworld",
  image_release_tag_prefix = "latest"
}]
