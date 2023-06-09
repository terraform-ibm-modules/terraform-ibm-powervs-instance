# Basic Power Virtual Server Instance Module Example

This example illustrates how to use the `powervs-instance` module.
It provisions the following infrastructure:
- Creates an IBM® Power Virtual Server Instance in a pre-existing PowerVS Workspace (which contains Public SSH key and pre-imported OS image) .
- Creates Volumes and Attaches it to the instance.
- Optional Instance Initialization for linux images only (Configure proxy settings, configure network services (NTP, DNS, NFS) and create files systems)

# Usage

Edit the input.tfvars file and deploy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_powervs_instance"></a> [powervs\_instance](#module\_powervs\_instance) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | `null` | no |
| <a name="input_powervs_cpu_proc_type"></a> [powervs\_cpu\_proc\_type](#input\_powervs\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_instance_init"></a> [powervs\_instance\_init](#input\_powervs\_instance\_init) | Setup Proxy client and create filesystems on OS. Supported for LINUX distribution only. | <pre>object({<br>    enable            = bool<br>    access_host_or_ip = string<br>    ssh_private_key   = string<br>  })</pre> | n/a | yes |
| <a name="input_powervs_instance_name"></a> [powervs\_instance\_name](#input\_powervs\_instance\_name) | Name of instance which will be created | `string` | `"pi"` | no |
| <a name="input_powervs_memory_size"></a> [powervs\_memory\_size](#input\_powervs\_memory\_size) | Amount of memory. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_network_services_config"></a> [powervs\_network\_services\_config](#input\_powervs\_network\_services\_config) | Configures network services NTP, NFS and DNS on PowerVS instance | <pre>object(<br>    {<br>      nfs = object({ enable = bool, nfs_server_path = string, nfs_client_path = string })<br>      dns = object({ enable = bool, dns_server_ip = string })<br>      ntp = object({ enable = bool, ntp_server_ip = string })<br>    }<br>  )</pre> | <pre>{<br>  "dns": {<br>    "dns_server_ip": "",<br>    "enable": false<br>  },<br>  "nfs": {<br>    "enable": false,<br>    "nfs_client_path": "",<br>    "nfs_server_path": ""<br>  },<br>  "ntp": {<br>    "enable": false,<br>    "ntp_server_ip": ""<br>  }<br>}</pre> | no |
| <a name="input_powervs_networks"></a> [powervs\_networks](#input\_powervs\_networks) | Existing list of subnets name to be attached to an instance. First network has to be a management network. | `list(any)` | n/a | yes |
| <a name="input_powervs_number_of_processors"></a> [powervs\_number\_of\_processors](#input\_powervs\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_os_image_name"></a> [powervs\_os\_image\_name](#input\_powervs\_os\_image\_name) | Image Name for PowerVS Instance | `string` | `"RHEL8-SP4-SAP"` | no |
| <a name="input_powervs_proxy_settings"></a> [powervs\_proxy\_settings](#input\_powervs\_proxy\_settings) | Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port>. Requires 'powervs\_instance\_init' variable to be set. | <pre>object(<br>    {<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | <pre>{<br>  "no_proxy_hosts": "161.0.0.0/8,10.0.0.0/8",<br>  "proxy_host_or_ip_port": "<ip:port>"<br>}</pre> | no |
| <a name="input_powervs_sap_profile_id"></a> [powervs\_sap\_profile\_id](#input\_powervs\_sap\_profile\_id) | SAP Profile ID for the amount of cores and memory. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). Required only when creating SAP instances. If this is mentioned then pi\_server\_type, pi\_cpu\_proc\_type, pi\_number\_of\_processors and pi\_memory\_size will not be taken into account | `string` | `"ush1-4x128"` | no |
| <a name="input_powervs_server_type"></a> [powervs\_server\_type](#input\_powervs\_server\_type) | Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_sshkey_name"></a> [powervs\_sshkey\_name](#input\_powervs\_sshkey\_name) | Name of the PowerVS SSH key to create | `string` | n/a | yes |
| <a name="input_powervs_storage_config"></a> [powervs\_storage\_config](#input\_powervs\_storage\_config) | Custom File systems to be created and attached to PowerVS instance. 'disk\_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | <pre>[<br>  {<br>    "count": "2",<br>    "mount": "/data",<br>    "name": "data",<br>    "size": "100",<br>    "tier": "tier1"<br>  },<br>  {<br>    "count": "2",<br>    "mount": "/log",<br>    "name": "log",<br>    "size": "20",<br>    "tier": "tier3"<br>  },<br>  {<br>    "count": "1",<br>    "mount": "/shared",<br>    "name": "shared",<br>    "size": "20",<br>    "tier": "tier1"<br>  }<br>]</pre> | no |
| <a name="input_powervs_workspace_name"></a> [powervs\_workspace\_name](#input\_powervs\_workspace\_name) | Name of the PowerVS Workspace to create | `string` | n/a | yes |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing IBM Cloud resource group name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_host_or_ip"></a> [access\_host\_or\_ip](#output\_access\_host\_or\_ip) | Access host or Bastion IP. |
| <a name="output_instance_mgmt_ip"></a> [instance\_mgmt\_ip](#output\_instance\_mgmt\_ip) | IP address of the management network interface of IBM PowerVS instance. |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | All private IP addresses (as a list) of IBM PowerVS instance. |
| <a name="output_instance_private_ips_info"></a> [instance\_private\_ips\_info](#output\_instance\_private\_ips\_info) | Complete info about all private IP addresses of IBM PowerVS instance. |
| <a name="output_powervs_network_services_config"></a> [powervs\_network\_services\_config](#output\_powervs\_network\_services\_config) | Network Services NTP, DNS, NFS configuration. |
| <a name="output_powervs_proxy_settings"></a> [powervs\_proxy\_settings](#output\_powervs\_proxy\_settings) | Proxy Server IP:Port |
| <a name="output_storage_configuration"></a> [storage\_configuration](#output\_storage\_configuration) | Storage configuration of PowerVS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
