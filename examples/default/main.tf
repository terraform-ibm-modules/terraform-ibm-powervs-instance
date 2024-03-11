
#####################################################
# Deploy PowerVS Instance
#####################################################

module "powervs_instance" {
  source = "../../"

  pi_workspace_guid          = local.pi_workspace_guid
  pi_ssh_public_key_name     = local.powervs_ssh_public_key.name
  pi_image_id                = local.pi_image_id
  pi_networks                = local.pi_networks
  pi_instance_name           = local.powervs_instance_name
  pi_sap_profile_id          = var.powervs_sap_profile_id
  pi_boot_image_storage_tier = "tier1"
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_storage_config          = var.powervs_storage_config
}
