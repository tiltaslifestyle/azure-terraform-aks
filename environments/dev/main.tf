# The main resource group for dev environment
resource "azurerm_resource_group" "infra" {
  name     = "rg-${var.application_name}-${var.environment}"
  location = var.location
}

module "shared_services" {
  source                   = "../../modules/shared_services"
  application_name         = var.application_name
  environment              = var.environment
  location                 = var.location
  purge_protection_enabled = var.purge_protection_enabled
}

module "network" {
  source              = "../../modules/network"
  application_name    = var.application_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.infra.name
}

module "compute" {
  source              = "../../modules/compute"
  application_name    = var.application_name
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.infra.name
  compute_subnet_id   = module.network.compute_subnet_id
}