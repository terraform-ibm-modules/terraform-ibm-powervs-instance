output "pi_instance_private_ips" {
  description = "All private IP addresses (as a list) of IBM PowerVS instance."
  value       = join(", ", [for ip in data.ibm_pi_instance.instance_ips_ds.networks[*].ip : format("%s", ip)])
}

output "pi_instance_primary_ip" {
  description = "IP address of the management network interface of IBM PowerVS instance."
  value       = data.ibm_pi_instance_ip.instance_primary_ip_ds.ip
}

output "pi_storage_configuration" {
  description = "Storage configuration of PowerVS instance"
  depends_on  = [ibm_pi_volume.create_volume]
  value = local.create_volumes ? [for index, vol in var.pi_storage_config :
    {
      name  = vol.name
      size  = vol.size
      tier  = vol.tier
      count = vol.count
      mount = vol.mount
      wwns  = join(",", [for wwn in local.instance_wwn_by_fs[vol.name] : lower(wwn)])
      }] : [{
      name = "", size = "", count = "", tier = "", mount = "", wwns = ""
  }]
}
