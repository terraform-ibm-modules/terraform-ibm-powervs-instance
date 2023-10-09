# Module pi_instance_init

This module configures the PowerVS instance and prepares the system.
- Configures proxy settings for access to internet (SQUID forward proxy)
- SUSE/RHEL OS Registration
- Update OS
- Install Packages (ansible, unbuffer)
- Run ansible galaxy roles to create filesystems and configure network services (NTP, NFS and DNS)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, <1.6.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 3.2.1 |
| <a name="requirement_time"></a> [time](#requirement\_time) | >= 0.9.1 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [null_resource.configure_network_services](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.configure_os](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pi_install_packages](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pi_proxy_settings](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.pi_update_os](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [time_sleep.pi_wait_for_reboot](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_host_or_ip"></a> [access\_host\_or\_ip](#input\_access\_host\_or\_ip) | Public IP of Bastion Host | `string` | n/a | yes |
| <a name="input_pi_network_services_config"></a> [pi\_network\_services\_config](#input\_pi\_network\_services\_config) | Configures network services NTP, NFS and DNS on PowerVS instance | <pre>object(<br>    {<br>      nfs = object({ enable = bool, nfs_server_path = string, nfs_client_path = string })<br>      dns = object({ enable = bool, dns_server_ip = string })<br>      ntp = object({ enable = bool, ntp_server_ip = string })<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_pi_proxy_settings"></a> [pi\_proxy\_settings](#input\_pi\_proxy\_settings) | Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port> | <pre>object(<br>    {<br>      enable                = string<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_pi_storage_config"></a> [pi\_storage\_config](#input\_pi\_storage\_config) | File systems to be created and mounted on PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. 'wwns' specifies the comma separated volume ids | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>    wwns  = string<br>  }))</pre> | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | Private Key to configure Instance, Will not be uploaded to server. | `string` | n/a | yes |
| <a name="input_target_server_ip"></a> [target\_server\_ip](#input\_target\_server\_ip) | Private IP of PowerVS instance reachable from the access host. | `string` | n/a | yes |

### Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
