#####################################################
# 1. Configure Squid client
# 2. Update OS and Reboot
# 3. Install Necessary Packages
# 4. Execute Ansible galaxy role to create filesystems
#####################################################

locals {
  scr_scripts_dir = "${path.module}/../terraform_templates/linux"
  dst_scripts_dir = "/root/terraform_scripts"

  src_services_init_tpl_path    = "${local.scr_scripts_dir}/services_init.sh.tftpl"
  dst_services_init_path        = "${local.dst_scripts_dir}/services_init.sh"
  src_install_packages_tpl_path = "${local.scr_scripts_dir}/install_packages.sh.tftpl"
  dst_install_packages_path     = "${local.dst_scripts_dir}/install_packages.sh"

  ansible_configure_os_playbook_name = "powervs-rhel.yml"
  src_ansible_exec_tpl_path          = "${local.scr_scripts_dir}/ansible_exec.sh.tftpl"
  dst_ansible_vars_configure_os_path = "${local.dst_scripts_dir}/ansible_configure_os.yml"
}

#####################################################
# 1. Configure Squid client
#####################################################

resource "null_resource" "pi_proxy_settings" {

  count = var.pi_proxy_settings != null && var.pi_proxy_settings["enable"] ? 1 : 0

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.access_host_or_ip
    host         = var.target_server_ip
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  ####### Create Terraform scripts directory ############
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.dst_scripts_dir}",
      "chmod 777 ${local.dst_scripts_dir}",
    ]
  }

  ####### Copy template file to target host ############
  provisioner "file" {
    destination = local.dst_services_init_path
    content = templatefile(
      local.src_services_init_tpl_path,
      {
        "proxy_ip_and_port" : var.pi_proxy_settings["proxy_host_or_ip_port"]
        "no_proxy_ip" : var.pi_proxy_settings["no_proxy_hosts"]
      }
    )
  }

  #######  Execute script: SQUID Forward Proxy client setup and OS Registration ############
  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.dst_services_init_path}",
      "${local.dst_services_init_path} setup_proxy",
      "${local.dst_services_init_path} register_os"
    ]
  }
}


#####################################################
# 2. Update OS and Reboot
#####################################################

resource "null_resource" "pi_update_os" {
  depends_on = [null_resource.pi_proxy_settings]
  count      = var.pi_proxy_settings != null && var.pi_proxy_settings["enable"] ? 1 : 0

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.access_host_or_ip
    host         = var.target_server_ip
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  ####### Create Terraform scripts directory , Update OS and Reboot ############
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.dst_scripts_dir}",
      "chmod 777 ${local.dst_scripts_dir}",
    ]
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    destination = local.dst_services_init_path
    content = templatefile(
      local.src_services_init_tpl_path,
      {
        "proxy_ip_and_port" : var.pi_proxy_settings["proxy_host_or_ip_port"]
        "no_proxy_ip" : var.pi_proxy_settings["no_proxy_hosts"]
      }
    )
  }

  ####### Update OS and Reboot ############
  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.dst_services_init_path}",
      "${local.dst_services_init_path} update_os",
    ]
  }
}

resource "time_sleep" "pi_wait_for_reboot" {
  depends_on = [null_resource.pi_update_os]

  create_duration = "120s"
}


#####################################################
# 3. Install Necessary Packages
#####################################################

resource "null_resource" "pi_install_packages" {
  depends_on = [time_sleep.pi_wait_for_reboot]
  count      = var.pi_proxy_settings != null && var.pi_proxy_settings["enable"] ? 1 : 0

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.access_host_or_ip
    host         = var.target_server_ip
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  ####### Create Terraform scripts directory ############
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.dst_scripts_dir}",
      "chmod 777 ${local.dst_scripts_dir}",
    ]
  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    destination = local.dst_install_packages_path
    content = templatefile(
      local.src_install_packages_tpl_path,
      {
        "install_packages" : true
      }
    )
  }

  #######  Execute script: Install packages ############
  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.dst_install_packages_path}",
      local.dst_install_packages_path
    ]
  }
}

#####################################################
# 4. Execute Ansible galaxy role to create filesystems
#####################################################

resource "null_resource" "configure_os" {
  depends_on = [null_resource.pi_install_packages]
  count      = var.pi_proxy_settings != null && var.pi_proxy_settings["enable"] ? 1 : 0

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.access_host_or_ip
    host         = var.target_server_ip
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  #### Write the variables required for ansible roles to file on target host ####
  provisioner "file" {
    destination = local.dst_ansible_vars_configure_os_path
    content     = <<EOF
disks_configuration : ${jsonencode(var.pi_storage_config)}
EOF

  }

  ####### Copy Template file to target host ############
  provisioner "file" {
    destination = "${local.dst_scripts_dir}/configure_os.sh"
    content = templatefile(
      local.src_ansible_exec_tpl_path,
      {
        "ansible_playbook_name" : local.ansible_configure_os_playbook_name
        "ansible_extra_vars_path" : local.dst_ansible_vars_configure_os_path
        "ansible_log_path" : local.dst_scripts_dir
      }
    )
  }

  ####  Execute ansible roles: prepare_sles/rhel_sap, powervs_fs_creation and powervs_swap_creation  ####
  provisioner "remote-exec" {
    inline = [
      "chmod +x ${local.dst_scripts_dir}/configure_os.sh",
      "${local.dst_scripts_dir}/configure_os.sh"
    ]
  }

}
