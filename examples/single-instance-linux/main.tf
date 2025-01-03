#####################################################
# Deploy PowerVS Instance
#####################################################

module "powervs_instance" {
  source = "../../"

  pi_workspace_guid          = var.powervs_workspace_guid
  pi_ssh_public_key_name     = var.powervs_ssh_public_key_name
  pi_image_id                = var.powervs_image_id
  pi_boot_image_storage_tier = var.powervs_boot_image_storage_tier
  pi_networks                = var.powervs_networks
  pi_instance_name           = var.powervs_instance_name
  pi_sap_profile_id          = var.powervs_sap_profile_id
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_placement_group_id      = var.powervs_placement_group_id
  pi_storage_config          = var.powervs_storage_config
  pi_existing_volume_ids     = var.powervs_existing_volume_ids
  pi_instance_init_linux     = var.powervs_instance_init_linux
  pi_network_services_config = var.powervs_network_services_config
  pi_user_tags               = var.powervs_user_tags
}
