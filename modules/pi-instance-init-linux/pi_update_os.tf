#####################################################
# 2. Update OS and Reboot
#####################################################

locals {
  src_update_os_tpl_path  = "${local.src_shell_templates_dir}/services_init.sh.tftpl"
  dst_update_os_file_path = "${local.dst_files_dir}/services_init.sh"

  pi_update_os = {
    # Creates terraform scripts directory
    provisioner_remote_exec_inline_pre_exec_commands = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}", ]

    # Copy template file to target host
    provisioner_file = {
      destination_file_path     = local.dst_update_os_file_path,
      source_template_file_path = local.src_update_os_tpl_path,
      template_content = {
        "proxy_ip_and_port" : var.pi_proxy_settings.proxy_host_or_ip_port
        "no_proxy_ip" : var.pi_proxy_settings.no_proxy_hosts
      }
    }

    # Execute script: Update OS
    provisioner_remote_exec_inline_post_exec_commands = [
      "chmod +x ${local.dst_update_os_file_path}",
      "${local.dst_update_os_file_path} update_os",
    ]
  }
}

module "pi_update_os" {
  source     = "../remote-exec-shell"
  depends_on = [module.pi_proxy_settings]

  bastion_host_ip                                   = var.bastion_host_ip
  host_ip                                           = var.target_server_ip
  ssh_private_key                                   = var.ssh_private_key
  provisioner_remote_exec_inline_pre_exec_commands  = local.pi_update_os.provisioner_remote_exec_inline_pre_exec_commands
  provisioner_file                                  = local.pi_update_os.provisioner_file
  provisioner_remote_exec_inline_post_exec_commands = local.pi_update_os.provisioner_remote_exec_inline_post_exec_commands
}

resource "time_sleep" "pi_wait_for_reboot" {
  depends_on = [module.pi_update_os]

  create_duration = "120s"
}
