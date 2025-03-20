module "pi_instance" {
  source = "./modules/pi-instance"

  pi_workspace_guid          = var.pi_workspace_guid
  pi_ssh_public_key_name     = var.pi_ssh_public_key_name
  pi_instance_name           = var.pi_instance_name
  pi_boot_image_id           = var.pi_image_id
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
  pi_affinity_policy         = var.pi_affinity_policy
  pi_affinity                = var.pi_affinity
  pi_anti_affinity           = var.pi_anti_affinity
  pi_user_tags               = var.pi_user_tags != null ? var.pi_user_tags : []

}

module "pi_instance_init_linux" {
  source     = "./modules/ansible"
  depends_on = [module.pi_instance]
  count      = var.pi_instance_init_linux != null ? var.pi_instance_init_linux.enable ? 1 : 0 : 0

  bastion_host_ip    = var.pi_instance_init_linux.bastion_host_ip
  ansible_host_or_ip = var.pi_instance_init_linux.ansible_host_or_ip
  ssh_private_key    = var.pi_instance_init_linux.ssh_private_key

  src_script_template_name = "linux-init/ansible_exec.sh.tftpl"
  dst_script_file_name     = "${var.pi_instance_name}_linux_init.sh"

  src_playbook_template_name = "linux-init/playbook-linux-init.yml.tftpl"
  dst_playbook_file_name     = "${var.pi_instance_name}-playbook-linux-init.yml"
  playbook_template_vars     = { "pi_storage_config" : jsonencode(module.pi_instance.pi_storage_configuration), "client_config" : jsonencode(var.pi_network_services_config), "pi_os_registration" : jsonencode(var.pi_instance_init_linux.custom_os_registration) }

  src_inventory_template_name = "pi-instance-inventory.tftpl"
  dst_inventory_file_name     = "${var.pi_instance_name}-instance-inventory"
  inventory_template_vars     = { "pi_instance_management_ip" : module.pi_instance.pi_instance_primary_ip }

  ansible_vault_password = var.pi_instance_init_linux.custom_os_registration != null ? var.ansible_vault_password : null
}
