output "tfstate_storage_account_name" {
  value       = azurerm_storage_account.tfstate.name
  description = "Copy this name to dev/prod versions.tf backend configuration"
}
