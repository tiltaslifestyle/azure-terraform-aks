module "shared_services" {
  source                   = "../../modules/shared_services"
  application_name         = var.application_name
  environment              = var.environment
  location                 = var.location
  purge_protection_enabled = var.purge_protection_enabled
}