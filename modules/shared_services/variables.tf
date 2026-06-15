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

variable "purge_protection_enabled" {
  description = "Enable purge protection for Key Vault (true/false)"
  type        = bool
}