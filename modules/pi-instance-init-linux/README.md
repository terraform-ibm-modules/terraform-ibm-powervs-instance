# Module pi-instance-init-linux

This module configures the Power Virtual Server instance and prepares the system.

- Configures proxy settings for access to internet (SQUID forward proxy)
- SUSE/RHEL OS Registration
- Update OS
- Install Packages (ansible, unbuffer)
- Optionally execute ansible galaxy collection roles [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) to create filesystems
- Optionally execute ansible galaxy collection roles [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) to configure network services (NTP, NFS and DNS)

## Usage
```hcl

module "pi_instance_init_linux" {
  source     = "terraform-ibm-modules/powervs-instance/ibm//modules//pi-instance-init"
  version    = "x.x.x" #replace x.x.x to lock to a specific version

  bastion_host_ip            = var.bastion_host_ip
  target_server_ip           = var.target_server_ip
  ssh_private_key            = var.ssh_private_key
  pi_proxy_settings          = var.pi_proxy_settings
  pi_storage_config          = var.pi_storage_config
  pi_network_services_config = var.pi_network_services_config
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pi_configure_network_services"></a> [pi\_configure\_network\_services](#module\_pi\_configure\_network\_services) | ../remote-exec-ansible | n/a |
| <a name="module_pi_create_filesystems"></a> [pi\_create\_filesystems](#module\_pi\_create\_filesystems) | ../remote-exec-ansible | n/a |
| <a name="module_pi_install_packages"></a> [pi\_install\_packages](#module\_pi\_install\_packages) | ../remote-exec-shell | n/a |
| <a name="module_pi_proxy_settings"></a> [pi\_proxy\_settings](#module\_pi\_proxy\_settings) | ../remote-exec-shell | n/a |
| <a name="module_pi_update_os"></a> [pi\_update\_os](#module\_pi\_update\_os) | ../remote-exec-shell | n/a |

### Resources

| Name | Type |
|------|------|
| [time_sleep.pi_wait_for_reboot](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_host_ip"></a> [bastion\_host\_ip](#input\_bastion\_host\_ip) | Public IP of Bastion Host | `string` | n/a | yes |
| <a name="input_pi_network_services_config"></a> [pi\_network\_services\_config](#input\_pi\_network\_services\_config) | Configures network services NTP, NFS and DNS on PowerVS instance | <pre>object(<br>    {<br>      nfs = object({ enable = bool, nfs_server_path = string, nfs_client_path = string })<br>      dns = object({ enable = bool, dns_server_ip = string })<br>      ntp = object({ enable = bool, ntp_server_ip = string })<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_pi_proxy_settings"></a> [pi\_proxy\_settings](#input\_pi\_proxy\_settings) | Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port> | <pre>object(<br>    {<br>      enable                = string<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_pi_storage_config"></a> [pi\_storage\_config](#input\_pi\_storage\_config) | File systems to be created and mounted on PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. 'wwns' specifies the comma separated volume ids | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>    wwns  = string<br>  }))</pre> | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Private Key to configure Instance, Will not be uploaded to server. | `string` | n/a | yes |
| <a name="input_target_server_ip"></a> [target\_server\_ip](#input\_target\_server\_ip) | Private IP of PowerVS instance reachable from the bastion host. | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
