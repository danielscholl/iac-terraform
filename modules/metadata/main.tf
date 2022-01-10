locals {

  # Global Tags
  default_tags = {
    terraform = "true"
  }

  # Azure Region
  location = local.naming_rules.azureRegion.allowed_values[var.location]

  # Naming metadata
  names = merge(
    {
      environment = var.environment
      location    = var.location
    },
    var.product != "" ? { product = var.product } : {}
  )

  # Tagging metadata
  tags = merge(
    {
      environment = local.naming_rules.environment.allowed_values[var.environment]
      location    = local.naming_rules.azureRegion.allowed_values[var.location]
    },

    var.product != "" ? { product = lookup(local.naming_rules.product.allowed_values, var.product, var.product) } : {},
    var.additional_tags,
    local.default_tags,
  )

  paired_regions = {
    eastus             = "westus"
    eastus2            = "centralus"
    southcentralus     = "northcentralus"
    westus2            = "westcentralus"
    australiaeast      = "australiasoutheast"
    southeastasia      = "eastasia"
    northeurope        = "westeurope"
    uksouth            = "ukwest"
    westeurope         = "northeurope"
    centralus          = "eastus2"
    northcentralus     = "southcentralus"
    westus             = "eastus"
    southafricanorth   = "southafricawest"
    centralindia       = "southindia"
    eastasia           = "southeastasia"
    japaneast          = "japanwest"
    koreacentral       = "koreasouth"
    canadacentral      = "canadaeast"
    francecentral      = "francesouth"
    germanywestcentral = "germanynorth"
    norwayeast         = "norwaywest"
    switzerlandnorth   = "switzerlandwest"
    uaenorth           = "uaecentral"
    brazilsouth        = "southcentralus"
    centraluseuap      = "eastus2euap"
    eastus2euap        = "centraluseuap"
    westcentralus      = "westus2"
    southafricawest    = "southafricanorth"
    australiacentral   = "australiacentral"
    australiacentral2  = "australiacentral2"
    australiasoutheast = "australiaeast"
    japanwest          = "japaneast"
    koreasouth         = "koreacentral"
    southindia         = "centralindia"
    westindia          = "southindia"
    canadaeast         = "canadacentral"
    francesouth        = "francecentral"
    germanynorth       = "germanywestcentral"
    norwaywest         = "norwayeast"
    switzerlandwest    = "switzerlandnorth"
    ukwest             = "uksouth"
    uaecentral         = "uaenorth"
    brazilsoutheast    = "brazilsouth",
    usgovarizona       = "usgovtexas",
    usgoviowa          = "usgovvirginia",
    usgovvirginia      = "usgovtexas"
    usgovtexas         = "usgovvirginia"
  }

}
