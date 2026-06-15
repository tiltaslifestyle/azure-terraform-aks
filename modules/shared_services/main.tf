resource "azurerm_resource_group" "shared" {
  name     = "rg-${var.application_name}-${var.environment}-shared"
  location = var.location
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

