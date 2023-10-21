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
    inline = var.remote_exec_inline_pre_exec_commands
  }

  ####### Copy first template file to target host ############
  provisioner "file" {
    content     = templatefile(var.remote_exec_file_provisioner_1.source_template_file_path, var.remote_exec_file_provisioner_1.template_content)
    destination = var.remote_exec_file_provisioner_1.destination_file_path
  }

  ####### Copy second template file to target host ############
  provisioner "file" {
    content     = templatefile(var.remote_exec_file_provisioner_2.source_template_file_path, var.remote_exec_file_provisioner_2.template_content)
    destination = var.remote_exec_file_provisioner_2.destination_file_path
  }

  #######   Execute commands on target host ############
  provisioner "remote-exec" {
    inline = var.remote_exec_inline_post_exec_commands
  }
}
