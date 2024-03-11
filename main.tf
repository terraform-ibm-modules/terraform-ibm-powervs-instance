module "pi_instance" {

  source = "./modules/pi-instance"

  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_instance_name           = var.pi_instance_name
  pi_image_id                = var.pi_image_id
  pi_boot_image_storage_tier = var.pi_boot_image_storage_tier
  pi_boot_image_storage_pool = var.pi_boot_image_storage_pool
  pi_networks                = var.pi_networks
  pi_sap_profile_id          = var.pi_sap_profile_id
  pi_server_type             = var.pi_server_type
  pi_cpu_proc_type           = var.pi_cpu_proc_type
  pi_number_of_processors    = var.pi_number_of_processors
  pi_memory_size             = var.pi_memory_size
  pi_existing_volume_ids     = var.pi_existing_volume_ids
  pi_storage_config          = var.pi_storage_config
  pi_placement_group_id      = var.pi_placement_group_id
  pi_replicants              = var.pi_replicants

}

module "pi_instance_init_linux" {
  source     = "./modules/pi-instance-init-linux"
  depends_on = [module.pi_instance]
  count      = var.pi_instance_init_linux != null ? var.pi_instance_init_linux.enable ? 1 : 0 : 0

  bastion_host_ip            = var.pi_instance_init_linux.bastion_host_ip
  target_server_ip           = module.pi_instance.pi_instance_primary_ip
  ssh_private_key            = var.pi_instance_init_linux.ssh_private_key
  pi_proxy_settings          = local.pi_linux_proxy_settings
  pi_storage_config          = module.pi_instance.pi_storage_configuration
  pi_network_services_config = var.pi_network_services_config

}
