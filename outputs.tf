output "pi_instance_name" {
  description = "Name of PowerVS instance."
  value       = module.pi_instance.pi_instance_name
}

output "pi_instance_id" {
  description = "he unique identifier of the instance. The ID is composed of <power_instance_id>/<instance_id>."
  value       = module.pi_instance.pi_instance_id
}

output "pi_instance_instance_id" {
  description = "The unique identifier of PowerVS instance."
  value       = module.pi_instance.pi_instance_instance_id
}

output "pi_instance_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS instance."
  value       = module.pi_instance.pi_instance_private_ips
}

output "pi_instance_primary_ip" {
  description = "IP address of the primary network interface of IBM PowerVS instance."
  value       = module.pi_instance.pi_instance_primary_ip
}

output "pi_storage_configuration" {
  description = "Storage configuration of PowerVS instance."
  value       = module.pi_instance.pi_storage_configuration
}
