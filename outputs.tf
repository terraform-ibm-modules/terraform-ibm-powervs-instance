output "pi_instance_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS instance."
  value       = module.pi_instance.pi_instance_private_ips
}

output "pi_instance_primary_ip" {
  description = "IP address of the management network interface of IBM PowerVS instance."
  value       = module.pi_instance.pi_instance_primary_ip
}

output "pi_storage_configuration" {
  description = "Storage configuration of PowerVS instance."
  value       = module.pi_instance.pi_storage_configuration
}
