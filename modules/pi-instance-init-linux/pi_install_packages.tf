#####################################################
# 3. Install Necessary Packages
#####################################################

locals {
  src_install_packages_tpl_path  = "${local.src_shell_templates_dir}/install_packages.sh.tftpl"
  dst_install_packages_file_path = "${local.dst_files_dir}/install_packages.sh"


  pi_install_packages = {
    # Creates terraform scripts directory
    remote_exec_inline_pre_exec_commands = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}", ]

    # Copy template file to target host
    remote_exec_file_provisioner = {
      destination_file_path     = local.dst_install_packages_file_path,
      source_template_file_path = local.src_install_packages_tpl_path,
      template_content          = { "install_packages" : true }
    }

    #  Execute script: Install packages
    remote_exec_inline_post_exec_commands = [
      "chmod +x ${local.dst_install_packages_file_path}",
      local.dst_install_packages_file_path,
    ]
  }
}

module "pi_install_packages" {
  source     = "../remote-exec-shell"
  depends_on = [time_sleep.pi_wait_for_reboot]
  count      = local.proxy_enabled ? 1 : 0

  bastion_host_ip                       = var.bastion_host_ip
  host_ip                               = var.target_server_ip
  ssh_private_key                       = var.ssh_private_key
  remote_exec_inline_pre_exec_commands  = local.pi_install_packages.remote_exec_inline_pre_exec_commands
  remote_exec_file_provisioner          = local.pi_install_packages.remote_exec_file_provisioner
  remote_exec_inline_post_exec_commands = local.pi_install_packages.remote_exec_inline_post_exec_commands
}
