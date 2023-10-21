resource "terraform_data" "remote_exec_shell" {

  connection {
    type         = "ssh"
    user         = "root"
    bastion_host = var.bastion_host_ip
    host         = var.host_ip
    private_key  = var.ssh_private_key
    agent        = false
    timeout      = "10m"
  }

  ####### Execute commands on target host ############
  provisioner "remote-exec" {
    inline = var.provisioner_remote_exec_inline_pre_exec_commands
  }

  ####### Copy template file to target host ############
  provisioner "file" {
    content     = templatefile(var.provisioner_file.source_template_file_path, var.provisioner_file.template_content)
    destination = var.provisioner_file.destination_file_path
  }

  ####### Execute commands on target host ############
  provisioner "remote-exec" {
    inline = var.provisioner_remote_exec_inline_post_exec_commands
  }
}
