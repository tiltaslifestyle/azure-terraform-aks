variable "application_name" {
  description = "The name of the application to be deployed"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
}

variable "location" {
  description = "The region where resources will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where network resources will be deployed"
  type        = string
}

variable "compute_subnet_id" {
  description = "The ID of the subnet where the VM NIC should be attached"
  type        = string
}