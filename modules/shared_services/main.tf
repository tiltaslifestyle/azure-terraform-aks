# Create a resource group for shared services
resource "azurerm_resource_group" "shared" {
  name     = "rg-${var.application_name}-${var.environment}-shared"
  location = var.location
}

# Create a random string for unique naming
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

# Create a Log Analytics workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.application_name}-${var.environment}"
  location            = azurerm_resource_group.shared.location
  resource_group_name = azurerm_resource_group.shared.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Get the context of Azure connection (your ID)
data "azurerm_client_config" "current" {}

# Create an Azure Key Vault
resource "azurerm_key_vault" "main" {
  name                        = "kv-${substr(var.application_name, 0, 4)}-${var.environment}-${random_string.suffix.result}"
  location                    = azurerm_resource_group.shared.location
  resource_group_name         = azurerm_resource_group.shared.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = var.purge_protection_enabled
  sku_name                    = "standard"
  rbac_authorization_enabled  = true
}

# Assign the current user the Key Vault Administrator role on the Key Vault
resource "azurerm_role_assignment" "terraform_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# Configure diagnostic settings to send logs and metrics from the Key Vault to the Log Analytics workspace
resource "azurerm_monitor_diagnostic_setting" "main" {
  name                       = "diag-${substr(var.application_name, 0, 4)}-${var.environment}-${random_string.suffix.result}"
  target_resource_id         = azurerm_key_vault.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}