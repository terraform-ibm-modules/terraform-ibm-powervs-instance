module "pi_instance" {

  source = "./modules/pi-instance"

  pi_workspace_guid       = var.pi_workspace_guid
  pi_ssh_public_key_name  = var.pi_ssh_public_key_name
  pi_instance_name        = var.pi_instance_name
  pi_image_id             = var.pi_image_id
  pi_networks             = var.pi_networks
  pi_sap_profile_id       = var.pi_sap_profile_id
  pi_server_type          = var.pi_server_type
  pi_cpu_proc_type        = var.pi_cpu_proc_type
  pi_number_of_processors = var.pi_number_of_processors
  pi_memory_size          = var.pi_memory_size
  pi_storage_config       = var.pi_storage_config

}

module "pi_instance_init_linux" {
  source     = "./modules/ansible"
  depends_on = [module.pi_instance]
  count      = var.pi_instance_init_linux != null ? var.pi_instance_init_linux.enable ? 1 : 0 : 0

  bastion_host_ip    = var.pi_instance_init_linux.bastion_host_ip
  ansible_host_or_ip = var.pi_instance_init_linux.ansible_host_or_ip
  ssh_private_key    = var.pi_instance_init_linux.ssh_private_key

  src_script_template_name    = "ansible_exec.sh.tftpl"
  dst_script_file_name        = "${var.pi_instance_name}_instance_init.sh"
  src_playbook_template_name  = "pi_instance_init_linux_playbook.yml.tftpl"
  dst_playbook_file_name      = "${var.pi_instance_name}_instance_init_playbook.yml"
  playbook_template_vars      = { "pi_storage_config" : jsonencode(module.pi_instance.pi_storage_configuration), "client_config" : jsonencode(var.pi_network_services_config) }
  src_inventory_template_name = "pi_instance_inventory.tftpl"
  dst_inventory_file_name     = "${var.pi_instance_name}_instance_inventory"
  inventory_template_vars     = { "pi_instance_management_ip" : module.pi_instance.pi_instance_primary_ip }

}
