#####################################################
# 1. Proxy Client setup
# 2. Register OS
#####################################################

locals {
  src_proxy_settings_tpl_path  = "${local.src_shell_templates_dir}/services_init.sh.tftpl"
  dst_proxy_settings_file_path = "${local.dst_files_dir}/services_init.sh"

  pi_proxy_settings = {
    # Creates terraform scripts directory
    remote_exec_inline_pre_exec_commands = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}", ]

    # Copy template file to target host
    remote_exec_file_provisioner = {
      destination_file_path     = local.dst_proxy_settings_file_path,
      source_template_file_path = local.src_proxy_settings_tpl_path,
      template_content = {
        "proxy_ip_and_port" : var.pi_proxy_settings.proxy_host_or_ip_port
        "no_proxy_ip" : var.pi_proxy_settings.no_proxy_hosts
      }
    }
    #######  Execute script: SQUID Forward Proxy client setup and OS Registration ############
    remote_exec_inline_post_exec_commands = [
      "chmod +x ${local.dst_proxy_settings_file_path}",
      "${local.dst_proxy_settings_file_path} setup_proxy",
      "${local.dst_proxy_settings_file_path} register_os"
    ]
  }
}

module "pi_proxy_settings" {
  source = "../remote-exec-shell"
  count  = local.proxy_enabled ? 1 : 0

  bastion_host_ip                       = var.bastion_host_ip
  host_ip                               = var.target_server_ip
  ssh_private_key                       = var.ssh_private_key
  remote_exec_inline_pre_exec_commands  = local.pi_proxy_settings.remote_exec_inline_pre_exec_commands
  remote_exec_file_provisioner          = local.pi_proxy_settings.remote_exec_file_provisioner
  remote_exec_inline_post_exec_commands = local.pi_proxy_settings.remote_exec_inline_post_exec_commands
}
