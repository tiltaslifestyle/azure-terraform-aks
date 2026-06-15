resource "azurerm_resource_group" "shared" {
  name     = "rg-${var.application_name}-${var.environment}-shared"
  location = var.location
}

resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.application_name}-${var.environment}"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}