module "pi_instance" {

  source = "./modules/pi_instance"

  pi_zone                 = var.pi_zone
  pi_resource_group_name  = var.pi_resource_group_name
  pi_workspace_name       = var.pi_workspace_name
  pi_sshkey_name          = var.pi_sshkey_name
  pi_instance_name        = var.pi_instance_name
  pi_os_image_name        = var.pi_os_image_name
  pi_networks             = var.pi_networks
  pi_sap_profile_id       = var.pi_sap_profile_id
  pi_server_type          = var.pi_server_type
  pi_cpu_proc_type        = var.pi_cpu_proc_type
  pi_number_of_processors = var.pi_number_of_processors
  pi_memory_size          = var.pi_memory_size
  pi_storage_config       = var.pi_storage_config

}

#####################################################
# Enable instance initialization for Linux only
#####################################################

locals {
  os_distribution = length(regexall(".*RHEL.*", var.pi_os_image_name)) > 0 || length(regexall(".*SLES.*", var.pi_os_image_name)) > 0 ? "linux" : "aix"

  pi_instance_init            = var.pi_instance_init != null ? local.os_distribution == "linux" && var.pi_instance_init["enable"] && var.pi_instance_init.access_host_or_ip != "" && var.pi_instance_init.access_host_or_ip != null && var.pi_instance_init.ssh_private_key != "" && var.pi_instance_init.ssh_private_key != null ? true : false : false
  pi_instance_init_validation = local.pi_instance_init ? true : var.pi_instance_init != null ? !var.pi_instance_init["enable"] ? true : false : false
  pi_instance_init_msg        = "pi_instance_init.enable is set to true, but pi_instance_init.access_host_or_ip or pi_instance_init.ssh_private_key has empty or null values."
  # tflint-ignore: terraform_unused_declarations
  pi_instance_init_chk = regex("^${local.pi_instance_init_msg}$", (local.pi_instance_init_validation ? local.pi_instance_init_msg : ""))

  pi_proxy_settings = {
    enable                = var.pi_proxy_settings != null ? var.pi_proxy_settings.proxy_host_or_ip_port != "" ? true : false : false
    proxy_host_or_ip_port = var.pi_proxy_settings != null ? var.pi_proxy_settings.proxy_host_or_ip_port != "" ? var.pi_proxy_settings.proxy_host_or_ip_port : "" : ""
    no_proxy_hosts        = var.pi_proxy_settings != null ? var.pi_proxy_settings.no_proxy_hosts != "" ? var.pi_proxy_settings.no_proxy_hosts : "" : ""
  }

}



module "pi_instance_init" {

  source     = "./modules/pi_instance_init"
  depends_on = [module.pi_instance]
  count      = local.pi_instance_init && local.pi_instance_init_validation ? 1 : 0

  access_host_or_ip = var.pi_instance_init.access_host_or_ip
  target_server_ip  = module.pi_instance.pi_instance_mgmt_ip
  ssh_private_key   = var.pi_instance_init.ssh_private_key
  pi_proxy_settings = local.pi_proxy_settings
  pi_storage_config = module.pi_instance.pi_storage_configuration
}
