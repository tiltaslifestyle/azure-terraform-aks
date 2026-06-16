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

variable "vnet_address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
  default     = ["10.26.0.0/16"] # Default address space for the virtual network (65,536 IP addresses)
}

variable "aks_subnet_cidr" {
  description = "The CIDR block for the AKS cluster"
  type        = list(string)
  default     = ["10.26.1.0/24"] # Default CIDR block for the AKS subnet (256 IP addresses)
}