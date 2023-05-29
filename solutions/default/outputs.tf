##############################################################################
# Outputs
##############################################################################

output "instance_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS instance."
  value       = module.powervs_instance.instance_private_ips
}

output "instance_private_ips_info" {
  description = "Complete info about all private IP addresses of IBM PowerVS instance."
  value       = module.powervs_instance.instance_private_ips_info
}

output "instance_mgmt_ip" {
  description = "IP address of the management network interface of IBM PowerVS instance."
  value       = module.powervs_instance.instance_mgmt_ip
}

output "storage_configuration" {
  description = "Storage configuration of PowerVS instance."
  value       = module.powervs_instance.storage_configuration
}
