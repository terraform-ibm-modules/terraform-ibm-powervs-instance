########################################################################################
# 1. Proxy Client setup                                :: pi_proxy_settings.tf
# 2. Update OS and Reboot                              :: pi_update_os.tf
# 3. Install Necessary Packages                        :: pi_install_packages.tf
# 4. Execute Ansible galaxy role to create filesystems :: pi_create_filesystems.tf
# 5. Execute Ansible galaxy role to connect to         :: pi_configure_network_services.tf
# network services (NTP, NFS, DNS)
#########################################################################################

locals {
  src_shell_templates_dir   = "${path.module}/templates-shell/"
  src_ansible_templates_dir = "${path.module}/templates-ansible/"
  dst_files_dir             = "/root/terraform_files"

  proxy_enabled = var.pi_proxy_settings != null ? var.pi_proxy_settings.enable ? true : false : false
}
