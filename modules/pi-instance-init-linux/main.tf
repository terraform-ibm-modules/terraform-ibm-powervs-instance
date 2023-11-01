########################################################################################
# 1. Proxy Client setup
# 2. Update OS and Reboot
# 3. Install Necessary Packages
# 4. Execute Ansible galaxy role to create filesystems
# 5. Execute Ansible galaxy role to connect to
# network services (NTP, NFS, DNS)
#########################################################################################

locals {
  proxy_enabled = var.pi_proxy_settings != null ? var.pi_proxy_settings.enable ? true : false : false
}

#####################################################
# 1. Proxy Client setup
# 2. Register OS
#####################################################

module "pi_proxy_settings" {
  source = "./remote-exec-shell"
  count  = local.proxy_enabled ? 1 : 0

  bastion_host             = var.bastion_host_ip
  host                     = var.target_server_ip
  ssh_private_key          = var.ssh_private_key
  src_script_template_name = "services_init.sh.tftpl"
  dst_script_file_name     = "services_init.sh"
  script_template_content  = { proxy_ip_and_port = var.pi_proxy_settings.proxy_host_or_ip_port, no_proxy_ip = var.pi_proxy_settings.no_proxy_hosts }
  script_commands = [
    "chmod +x /root/terraform_files/services_init.sh",
    "/root/terraform_files/services_init.sh setup_proxy",
    "/root/terraform_files/services_init.sh register_os"
  ]
}


#####################################################
# 2. Update OS and Reboot
#####################################################

module "pi_update_os" {
  source     = "./remote-exec-shell"
  depends_on = [module.pi_proxy_settings]

  bastion_host             = var.bastion_host_ip
  host                     = var.target_server_ip
  ssh_private_key          = var.ssh_private_key
  src_script_template_name = "services_init.sh.tftpl"
  dst_script_file_name     = "services_init.sh"
  script_template_content  = { proxy_ip_and_port = var.pi_proxy_settings.proxy_host_or_ip_port, no_proxy_ip = var.pi_proxy_settings.no_proxy_hosts }
  script_commands = [
    "chmod +x /root/terraform_files/services_init.sh",
    "/root/terraform_files/services_init.sh update_os",
  ]
}

resource "time_sleep" "pi_wait_for_reboot" {
  depends_on = [module.pi_update_os]

  create_duration = "120s"
}


#####################################################
# 3. Install Necessary Packages
#####################################################

module "pi_install_packages" {
  source     = "./remote-exec-shell"
  depends_on = [time_sleep.pi_wait_for_reboot]

  bastion_host             = var.bastion_host_ip
  host                     = var.target_server_ip
  ssh_private_key          = var.ssh_private_key
  src_script_template_name = "install_packages.sh.tftpl"
  dst_script_file_name     = "install_packages.sh"
  script_template_content  = { install_packages = true }
  script_commands = [
    "chmod +x /root/terraform_files/install_packages.sh",
    "/root/terraform_files/install_packages.sh",
  ]
}


#######################################################
# 4. Execute Ansible galaxy role to create filesystems
#######################################################

module "pi_create_filesystems" {
  source     = "./remote-exec-ansible"
  depends_on = [module.pi_install_packages]


  bastion_host               = var.bastion_host_ip
  host                       = var.target_server_ip
  ssh_private_key            = var.ssh_private_key
  src_script_template_name   = "ansible_exec.sh.tftpl"
  dst_script_file_name       = "create_filesystems.sh"
  src_playbook_template_name = "playbook_create_filesystems.yml.tftpl"
  dst_playbook_file_name     = "playbook_create_filesystems.yml"
  playbook_template_content  = { pi_storage_config = jsonencode(var.pi_storage_config) }

}


#####################################################
# 5. Execute Ansible galaxy role to connect to
# network services (NTP, NFS, DNS)
#####################################################

module "pi_configure_network_services" {
  source     = "./remote-exec-ansible"
  depends_on = [module.pi_create_filesystems]
  count      = var.pi_network_services_config != null ? var.pi_network_services_config.dns.enable || var.pi_network_services_config.ntp.enable || var.pi_network_services_config.nfs.enable ? 1 : 0 : 0

  bastion_host               = var.bastion_host_ip
  host                       = var.target_server_ip
  ssh_private_key            = var.ssh_private_key
  src_script_template_name   = "ansible_exec.sh.tftpl"
  dst_script_file_name       = "configure_network_services.sh"
  src_playbook_template_name = "playbook_configure_network_services.yml.tftpl"
  dst_playbook_file_name     = "playbook_configure_network_services.yml"
  playbook_template_content  = { client_config = jsonencode(var.pi_network_services_config) }

}
