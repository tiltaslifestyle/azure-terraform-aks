module "aks_cluster" {
  source  = "Azure/avm-res-containerservice-managedcluster/azurerm"
  version = "0.6.4"

  name      = "aks-${var.application_name}-${var.environment}"
  location  = var.location
  parent_id = var.resource_group_id

  sku = {
    name = "Base"
    tier = var.sku_tier
  }

  # System node pool only for cluster system components 
  default_agent_pool = {
    name            = "systempool"
    count_of        = 1
    vm_size         = "Standard_B2s_v2"
    os_disk_size_gb = 30
    os_sku          = "AzureLinux"
    vnet_subnet_id  = var.aks_subnet_id
  }

  # User node pool for workloads (user pods)
  agent_pools = {
    workload = {
      name            = "workload"
      count_of        = var.workload_node_count
      vm_size         = "Standard_B2s_v2"
      os_type         = "Linux"
      os_sku          = "AzureLinux"
      mode            = "User"
      os_disk_size_gb = 30
      vnet_subnet_id  = var.aks_subnet_id
    }
  }

  network_profile = {
    network_plugin = "azure"
    network_policy = "azure"
  }

  # System-assigned identity for cluster control plane
  managed_identities = {
    system_assigned = true
  }

  # RBAC for cluster access control
  enable_rbac            = true
  disable_local_accounts = false
}