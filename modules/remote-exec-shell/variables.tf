variable "bastion_host_ip" {
  description = "Public IP of bastion host."
  type        = string
}

variable "host_ip" {
  description = "Private IP of instance reachable from the bastion host."
  type        = string
}

variable "ssh_private_key" {
  description = "Private Key to configure instance, will not be uploaded to server."
  type        = string
  sensitive   = true
}

variable "provisioner_remote_exec_inline_pre_exec_commands" {
  description = "List of commands to be executed on target host. This variable will be executed first."
  type        = list(any)
}

variable "provisioner_file" {
  description = "Template file to be copied from local to remote host. This will be executed after contents of 'provisioner_remote_exec_inline_pre_exec_commands' variable."
  type = object(
    {
      template_content          = map(any)
      source_template_file_path = string
      destination_file_path     = string
    }
  )
}

variable "provisioner_remote_exec_inline_post_exec_commands" {
  description = "List of commands to be executed on target host. This variable will be executed last. This will be executed after provisioning of template file 'provisioner_file' variable."
  type        = list(any)
}
