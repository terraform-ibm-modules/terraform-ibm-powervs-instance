#####################################################
# 5. Execute Ansible galaxy role to connect to
# network services (NTP, NFS, DNS)
#####################################################

locals {
  src_configure_network_services_tpl_path           = "${local.src_ansible_templates_dir}/ansible_exec.sh.tftpl"
  dst_configure_network_services_file_path          = "${local.dst_files_dir}/configure_network_services.sh"
  src_playbook_configure_network_services_tpl_path  = "${local.src_ansible_templates_dir}/playbook_configure_network_services.yml.tftpl"
  dst_playbook_configure_network_services_file_path = "${local.dst_files_dir}/playbook_configure_network_services.yml"

  pi_configure_network_services = {
    # Creates terraform scripts directory
    remote_exec_inline_pre_exec_commands = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}", ]

    # Copy playbook template file to target host
    remote_exec_file_provisioner_1 = {
      destination_file_path     = local.dst_playbook_configure_network_services_file_path,
      source_template_file_path = local.src_playbook_configure_network_services_tpl_path,
      template_content = {
        "client_config" : jsonencode(var.pi_network_services_config)
      }
    }

    # Copy ansible exec template file to target host
    remote_exec_file_provisioner_2 = {
      destination_file_path     = local.dst_configure_network_services_file_path,
      source_template_file_path = local.src_configure_network_services_tpl_path,
      template_content = {
        "ansible_playbook_file" : local.dst_playbook_configure_network_services_file_path
        "ansible_log_path" : local.dst_files_dir
      }
    }

    #  Execute script: configure_network_services.sh
    remote_exec_inline_post_exec_commands = [
      "chmod +x ${local.dst_configure_network_services_file_path}",
      local.dst_configure_network_services_file_path,
    ]
  }
}

module "pi_configure_network_services" {
  source     = "../remote-exec-ansible"
  depends_on = [module.pi_install_packages]
  count      = local.proxy_enabled && var.pi_network_services_config != null ? 1 : 0

  bastion_host_ip                       = var.bastion_host_ip
  host_ip                               = var.target_server_ip
  ssh_private_key                       = var.ssh_private_key
  remote_exec_inline_pre_exec_commands  = local.pi_configure_network_services.remote_exec_inline_pre_exec_commands
  remote_exec_file_provisioner_1        = local.pi_configure_network_services.remote_exec_file_provisioner_1
  remote_exec_file_provisioner_2        = local.pi_configure_network_services.remote_exec_file_provisioner_2
  remote_exec_inline_post_exec_commands = local.pi_configure_network_services.remote_exec_inline_post_exec_commands
}
