# Module remote-exec-ansible

This module uses a terraform_data resource to perform following operations on a host behind a jump/bastion/access host_or_ip in following order:

- Executes a list of inline commands as first remote-exec provisioner.
- Executes a first file provisioner to copy a file to remote host using a template file allowing to write content.
- Executes a second file provisioner to copy a file to remote host using a template file allowing to write content.
- Executes a list of inline commands as last remote-exec provisioner.

## Usage
```hcl

module "configure_os" {
  source     = "terraform-ibm-modules/powervs-instance/ibm//modules//remote-exec-ansible"
  version    = "x.x.x" #replace x.x.x to lock to a specific version

  bastion_host_ip                       = var.bastion_host_ip
  host_ip                               = var.host_ip
  ssh_private_key                       = var.ssh_private_key
  remote_exec_inline_pre_exec_commands  = var.remote_exec_inline_pre_exec_commands
  remote_exec_file_provisioner_1        = var.remote_exec_file_provisioner_1
  remote_exec_file_provisioner_2        = var.remote_exec_file_provisioner_2
  remote_exec_inline_post_exec_commands = var.remote_exec_inline_post_exec_commands
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [terraform_data.remote_exec_ansible](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_host_ip"></a> [bastion\_host\_ip](#input\_bastion\_host\_ip) | Public IP of Bastion Host | `string` | n/a | yes |
| <a name="input_host_ip"></a> [host\_ip](#input\_host\_ip) | Private IP of instance reachable from the Bastion Host. | `string` | n/a | yes |
| <a name="input_remote_exec_file_provisioner_1"></a> [remote\_exec\_file\_provisioner\_1](#input\_remote\_exec\_file\_provisioner\_1) | First template file to be copied from local to remote host. This will be executed after contents of 'remote\_exec\_inline\_pre\_exec\_commands' variable. | <pre>object(<br>    {<br>      template_content          = map(any)<br>      source_template_file_path = string<br>      destination_file_path     = string<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_remote_exec_file_provisioner_2"></a> [remote\_exec\_file\_provisioner\_2](#input\_remote\_exec\_file\_provisioner\_2) | Template file to be copied from local to remote host. This will be executed after contents of 'remote\_exec\_inline\_pre\_exec\_commands\_1' variable. | <pre>object(<br>    {<br>      template_content          = map(any)<br>      source_template_file_path = string<br>      destination_file_path     = string<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_remote_exec_inline_post_exec_commands"></a> [remote\_exec\_inline\_post\_exec\_commands](#input\_remote\_exec\_inline\_post\_exec\_commands) | List of commands to be executed on target host. This variable will be executed last. This will be executed after provisioning of template file 'remote\_exec\_file\_provisioner\_2' variable. | `list(any)` | n/a | yes |
| <a name="input_remote_exec_inline_pre_exec_commands"></a> [remote\_exec\_inline\_pre\_exec\_commands](#input\_remote\_exec\_inline\_pre\_exec\_commands) | List of Commands to be executed on target host. This variable will be executed first. | `list(any)` | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Private Key to configure Instance, will not be uploaded to server. | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->