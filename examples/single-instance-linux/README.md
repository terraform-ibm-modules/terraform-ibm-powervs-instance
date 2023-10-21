# Basic Power Virtual Server instance with OS initialization

This example illustrates how to use the `powervs-instance` module.

It provisions the following components in IBM cloud:

- Creates an IBM® Power Virtual Server Instance in a pre-existing PowerVS Workspace (which contains Public SSH key and pre-imported OS image).
- Creates volumes and attaches it to the instance.
- Optional Instance Initialization for linux images only (Configure proxy settings, configure network services (NTP, DNS, NFS) and create files systems).


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_powervs_instance"></a> [powervs\_instance](#module\_powervs\_instance) | ../../ | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ibmcloud_api_key"></a> [ibmcloud\_api\_key](#input\_ibmcloud\_api\_key) | The IBM Cloud platform API key needed to deploy IAM enabled resources. | `string` | n/a | yes |
| <a name="input_powervs_cpu_proc_type"></a> [powervs\_cpu\_proc\_type](#input\_powervs\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_image_id"></a> [powervs\_image\_id](#input\_powervs\_image\_id) | Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images | `string` | n/a | yes |
| <a name="input_powervs_instance_init_linux"></a> [powervs\_instance\_init\_linux](#input\_powervs\_instance\_init\_linux) | Setup Proxy client and create filesystems on OS. Supported for LINUX distribution only. | <pre>object({<br>    enable          = bool<br>    bastion_host_ip = string<br>    ssh_private_key = string<br>  })</pre> | n/a | yes |
| <a name="input_powervs_instance_name"></a> [powervs\_instance\_name](#input\_powervs\_instance\_name) | Name of instance which will be created | `string` | n/a | yes |
| <a name="input_powervs_memory_size"></a> [powervs\_memory\_size](#input\_powervs\_memory\_size) | Amount of memory. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_network_services_config"></a> [powervs\_network\_services\_config](#input\_powervs\_network\_services\_config) | Configures network services NTP, NFS and DNS on PowerVS instance | <pre>object(<br>    {<br>      nfs = object({ enable = bool, nfs_server_path = string, nfs_client_path = string })<br>      dns = object({ enable = bool, dns_server_ip = string })<br>      ntp = object({ enable = bool, ntp_server_ip = string })<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_powervs_networks"></a> [powervs\_networks](#input\_powervs\_networks) | Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. | <pre>list(<br>    object({<br>      name = string<br>      id   = string<br>      cidr = optional(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_powervs_number_of_processors"></a> [powervs\_number\_of\_processors](#input\_powervs\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_proxy_settings"></a> [powervs\_proxy\_settings](#input\_powervs\_proxy\_settings) | Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port>. Requires 'powervs\_instance\_init' variable to be set. | <pre>object(<br>    {<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_powervs_sap_profile_id"></a> [powervs\_sap\_profile\_id](#input\_powervs\_sap\_profile\_id) | SAP Profile ID for the amount of cores and memory. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). Required only when creating SAP instances. If this is mentioned then pi\_server\_type, pi\_cpu\_proc\_type, pi\_number\_of\_processors and pi\_memory\_size will not be taken into account | `string` | `"ush1-4x128"` | no |
| <a name="input_powervs_server_type"></a> [powervs\_server\_type](#input\_powervs\_server\_type) | Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with powervs\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_powervs_ssh_public_key_name"></a> [powervs\_ssh\_public\_key\_name](#input\_powervs\_ssh\_public\_key\_name) | Name of the PowerVS SSH key to create | `string` | n/a | yes |
| <a name="input_powervs_storage_config"></a> [powervs\_storage\_config](#input\_powervs\_storage\_config) | Custom File systems to be created and attached to PowerVS instance. 'disk\_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | <pre>[<br>  {<br>    "count": "2",<br>    "mount": "/data",<br>    "name": "data",<br>    "size": "100",<br>    "tier": "tier1"<br>  },<br>  {<br>    "count": "2",<br>    "mount": "/log",<br>    "name": "log",<br>    "size": "20",<br>    "tier": "tier3"<br>  },<br>  {<br>    "count": "1",<br>    "mount": "/shared",<br>    "name": "shared",<br>    "size": "20",<br>    "tier": "tier1"<br>  }<br>]</pre> | no |
| <a name="input_powervs_workspace_guid"></a> [powervs\_workspace\_guid](#input\_powervs\_workspace\_guid) | Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account | `string` | n/a | yes |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_instance_primary_ip"></a> [pi\_instance\_primary\_ip](#output\_pi\_instance\_primary\_ip) | IP address of the primary network interface of IBM PowerVS instance. |
| <a name="output_pi_instance_private_ips"></a> [pi\_instance\_private\_ips](#output\_pi\_instance\_private\_ips) | All private IP addresses (as a list) of IBM PowerVS instance. |
| <a name="output_pi_storage_configuration"></a> [pi\_storage\_configuration](#output\_pi\_storage\_configuration) | Storage configuration of PowerVS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->