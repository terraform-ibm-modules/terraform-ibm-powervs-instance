#####################################################
# 1. Proxy Client setup
# 2. Update OS and Reboot
# 3. Install Necessary Packages
# 4. Execute Ansible galaxy role to create filesystems
# 5. Execute Ansible galaxy role to connect to
# network services (NTP, NFS, DNS)
#####################################################

locals {
  src_shell_templates_dir   = "${path.module}/templates-shell/"
  src_ansible_templates_dir = "${path.module}/templates-ansible/"
  dst_files_dir             = "/root/terraform_files"

  proxy_enabled = var.pi_proxy_settings != null ? var.pi_proxy_settings.enable ? true : false : false
}
