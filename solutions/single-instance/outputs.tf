##############################################################################
# Outputs
##############################################################################
output "access_host_or_ip" {
  description = "Access host or Bastion IP."
  value       = var.powervs_instance_init != null ? var.powervs_instance_init.access_host_or_ip != "" && var.powervs_instance_init.access_host_or_ip != null ? var.powervs_instance_init.access_host_or_ip : null : null
}

output "powervs_proxy_settings" {
  description = "Proxy Server IP:Port"
  value       = var.powervs_proxy_settings != null ? var.powervs_proxy_settings.proxy_host_or_ip_port != "" && var.powervs_proxy_settings.proxy_host_or_ip_port != null ? var.powervs_proxy_settings.proxy_host_or_ip_port : null : null
}

output "instance_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS instance."
  value       = module.powervs_instance.pi_instance_private_ips
}

output "instance_private_ips_info" {
  description = "Complete info about all private IP addresses of IBM PowerVS instance."
  value       = module.powervs_instance.pi_instance_private_ips_info
}

output "instance_mgmt_ip" {
  description = "IP address of the management network interface of IBM PowerVS instance."
  value       = module.powervs_instance.pi_instance_mgmt_ip
}

output "storage_configuration" {
  description = "Storage configuration of PowerVS instance."
  value       = module.powervs_instance.pi_storage_configuration
}

output "powervs_network_services_config" {
  description = "Network Services NTP, DNS, NFS configuration."
  value       = var.powervs_network_services_config != null ? var.powervs_network_services_config : null
}
