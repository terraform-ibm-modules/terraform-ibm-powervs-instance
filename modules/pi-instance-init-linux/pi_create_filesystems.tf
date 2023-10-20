#######################################################
# 4. Execute Ansible galaxy role to create filesystems
#######################################################

locals {
  src_create_filesystems_tpl_path           = "${local.src_ansible_templates_dir}/ansible_exec.sh.tftpl"
  dst_create_filesystems_file_path          = "${local.dst_files_dir}/create_filesystems.sh"
  src_playbook_create_filesystems_tpl_path  = "${local.src_ansible_templates_dir}/playbook_create_filesystems.yml.tftpl"
  dst_playbook_create_filesystems_file_path = "${local.dst_files_dir}/playbook_create_filesystems.yml"

  pi_create_filesystems = {
    # Creates terraform scripts directory
    remote_exec_inline_pre_exec_commands = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}", ]

    # Copy playbook template file to target host
    remote_exec_file_provisioner_1 = {
      destination_file_path     = local.dst_playbook_create_filesystems_file_path,
      source_template_file_path = local.src_playbook_create_filesystems_tpl_path,
      template_content = {
        "pi_storage_config" : jsonencode(var.pi_storage_config)
      }
    }

    # Copy ansible exec template file to target host
    remote_exec_file_provisioner_2 = {
      destination_file_path     = local.dst_create_filesystems_file_path,
      source_template_file_path = local.src_create_filesystems_tpl_path,
      template_content = {
        "ansible_playbook_file" : local.dst_playbook_create_filesystems_file_path
        "ansible_log_path" : local.dst_files_dir
      }
    }

    #  Execute script: create_filesystems.sh
    remote_exec_inline_post_exec_commands = [
      "chmod +x ${local.dst_create_filesystems_file_path}",
      local.dst_create_filesystems_file_path,
    ]
  }
}

module "pi_create_filesystems" {
  source     = "../remote-exec-ansible"
  depends_on = [module.pi_install_packages]
  count      = local.proxy_enabled && var.pi_storage_config != null ? var.pi_storage_config[0].count != "" ? 1 : 0 : 0

  bastion_host_ip                       = var.bastion_host_ip
  host_ip                               = var.target_server_ip
  ssh_private_key                       = var.ssh_private_key
  remote_exec_inline_pre_exec_commands  = local.pi_create_filesystems.remote_exec_inline_pre_exec_commands
  remote_exec_file_provisioner_1        = local.pi_create_filesystems.remote_exec_file_provisioner_1
  remote_exec_file_provisioner_2        = local.pi_create_filesystems.remote_exec_file_provisioner_2
  remote_exec_inline_post_exec_commands = local.pi_create_filesystems.remote_exec_inline_post_exec_commands
}
