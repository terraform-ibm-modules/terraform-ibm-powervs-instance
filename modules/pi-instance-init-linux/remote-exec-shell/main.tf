#####################################################
# Execute bash scripts
#####################################################

locals {
  dst_files_dir           = "/root/terraform_files"
  src_shell_templates_dir = "${path.module}/../templates-shell"

  src_script_tftpl_path = "${local.src_shell_templates_dir}/${var.src_script_template_name}"
  dst_script_file_path  = "${local.dst_files_dir}/${var.dst_script_file_name}"
}

resource "terraform_data" "remote_exec_shell" {

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host
    host         = var.host
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  ####### Execute commands on target host ############
  provisioner "remote-exec" {
    inline = ["mkdir -p ${local.dst_files_dir}", "chmod 777 ${local.dst_files_dir}", ]
  }

  ####### Copy template file to target host ############
  provisioner "file" {
    content     = templatefile(local.src_script_tftpl_path, var.script_template_content)
    destination = local.dst_script_file_path
  }

  ####### Execute commands on target host ############
  provisioner "remote-exec" {
    inline = var.script_commands
  }
}
