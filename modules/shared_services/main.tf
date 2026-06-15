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

resource "azurerm_role_assignment" "terraform_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}