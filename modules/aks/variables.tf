variable "application_name" {
  description = "The name of the application"
  type        = string
}

variable "environment" {
  description = "The environment for the deployment"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "resource_group_id" {
  description = "Full resource group id: /subscriptions/<sub>/resourceGroups/<name>"
  type        = string
}

variable "aks_subnet_id" {
  description = "Subnet id for AKS nodes"
  type        = string
}

variable "sku_tier" {
  description = "AKS SKU tier"
  type        = string
  default     = "Free"
}

variable "workload_node_count" {
  description = "Number of nodes in the workload (user) pool"
  type        = number
  default     = 1
}
