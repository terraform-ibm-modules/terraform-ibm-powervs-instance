resource "terraform_data" "remote_exec_ansible" {

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

  ####### Copy first template file to target host ############
  provisioner "file" {
    content     = templatefile(var.provisioner_file_1.source_template_file_path, var.provisioner_file_1.template_content)
    destination = var.provisioner_file_1.destination_file_path
  }

  ####### Copy second template file to target host ############
  provisioner "file" {
    content     = templatefile(var.provisioner_file_2.source_template_file_path, var.provisioner_file_2.template_content)
    destination = var.provisioner_file_2.destination_file_path
  }

  #######   Execute commands on target host ############
  provisioner "remote-exec" {
    inline = var.provisioner_remote_exec_inline_post_exec_commands
  }
}
