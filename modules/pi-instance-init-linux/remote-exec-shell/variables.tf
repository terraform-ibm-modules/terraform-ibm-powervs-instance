variable "bastion_host" {
  description = "Public IP of bastion host."
  type        = string
}

variable "host" {
  description = "Private IP of instance reachable from the bastion host."
  type        = string
}

variable "ssh_private_key" {
  description = "Private Key to configure instance, will not be uploaded to server."
  type        = string
  sensitive   = true
}

variable "src_script_template_name" {
  description = "Bash template script filename."
  type        = string
}

variable "dst_script_file_name" {
  description = "Bash script filename."
  type        = string
}

variable "script_template_content" {
  description = "Script template content."
  type        = map(any)
}

variable "script_commands" {
  description = "List of commands to be executed on target host."
  type        = list(any)
}
