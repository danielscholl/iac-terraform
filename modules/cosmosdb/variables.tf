##############################################################
# This module allows the creation of a Cosmos Database
##############################################################

variable "name" {
  description = "The name that CosmosDB Account will be created with."
  type        = string
}

variable "resource_group" {
  description = "The Resource group to contain the CosmosDB Account"
  type        = string
}

variable "kind" {
  description = "Determines the kind of CosmosDB to create. Can either be 'GlobalDocumentDB' or 'MongoDB'."
  type        = string
  default     = "GlobalDocumentDB"
}

variable "automatic_failover" {
  description = "Determines if automatic failover is enabled for the created CosmosDB."
  default     = false
}

variable "consistency_level" {
  description = "The Consistency Level to use for this CosmosDB Account. Can be either 'BoundedStaleness', 'Eventual', 'Session', 'Strong' or 'ConsistentPrefix'."
  type        = string
  default     = "Session"
}

variable "primary_replica_location" {
  description = "The name of the Azure region to host replicated data."
  type        = string
}

variable "database_name" {
  description = "The database name that CosmosDB Sql will be created with."
  type        = string
}

variable "container_name" {
  description = "The container name that CosmosDB Sql will be created with."
  type        = string
}
