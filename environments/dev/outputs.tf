# output "vm_public_ip" {
#   value       = module.compute.vm_public_ip
#   description = "The public IP address of the virtual machine"
# }

output "cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.cluster_name
}