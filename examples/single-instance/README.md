# Basic Power Virtual Server Instance Module Example

This example illustrates how to use the `powervs-instance` module.
It provisions the following infrastructure:
- Creates an IBM® Power Virtual Server Instance in a pre-existing PowerVS Workspace (which contains Public SSH key and pre-imported OS image) .
- Creates Volumes and Attaches it to the instance.
- Optional Instance Initialization for linux images only (Configure proxy settings and create files systems)

# Usage

Edit the input.tfvars file and deploy

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.5 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | =1.52.0 |

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
| <a name="input_powervs_instance_init"></a> [powervs\_instance\_init](#input\_powervs\_instance\_init) | Setup Proxy client and create filesystems on OS. Supported for LINUX distribution only. | <pre>object({<br>    enable            = bool<br>    access_host_or_ip = string<br>    ssh_private_key   = string<br>  })</pre> | n/a | yes |
| <a name="input_powervs_instance_name"></a> [powervs\_instance\_name](#input\_powervs\_instance\_name) | Name of instance which will be created | `string` | `"pi"` | no |
| <a name="input_powervs_networks"></a> [powervs\_networks](#input\_powervs\_networks) | Existing list of subnets name to be attached to an instance. First network has to be a management network. | `list(any)` | n/a | yes |
| <a name="input_powervs_os_image_name"></a> [powervs\_os\_image\_name](#input\_powervs\_os\_image\_name) | Image Name for PowerVS Instance | `string` | `"RHEL8-SP4-SAP"` | no |
| <a name="input_powervs_proxy_settings"></a> [powervs\_proxy\_settings](#input\_powervs\_proxy\_settings) | Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port>. Requires 'powervs\_instance\_init' variable to be set. | <pre>object(<br>    {<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | <pre>{<br>  "no_proxy_hosts": "161.0.0.0/8,10.0.0.0/8",<br>  "proxy_host_or_ip_port": "<ip:port>"<br>}</pre> | no |
| <a name="input_powervs_sap_profile_id"></a> [powervs\_sap\_profile\_id](#input\_powervs\_sap\_profile\_id) | SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then powervs\_server\_type, powervs\_cpu\_proc\_type, powervs\_number\_of\_processors and powervs\_memory\_size will not be taken into account | `string` | `"ush1-4x128"` | no |
| <a name="input_powervs_sshkey_name"></a> [powervs\_sshkey\_name](#input\_powervs\_sshkey\_name) | Name of the PowerVS SSH key to create | `string` | n/a | yes |
| <a name="input_powervs_storage_config"></a> [powervs\_storage\_config](#input\_powervs\_storage\_config) | Custom File systems to be created and attached to PowerVS instance. 'disk\_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | <pre>[<br>  {<br>    "count": "2",<br>    "mount": "/data",<br>    "name": "data",<br>    "size": "100",<br>    "tier": "tier1"<br>  },<br>  {<br>    "count": "2",<br>    "mount": "/log",<br>    "name": "log",<br>    "size": "20",<br>    "tier": "tier3"<br>  },<br>  {<br>    "count": "1",<br>    "mount": "/shared",<br>    "name": "shared",<br>    "size": "20",<br>    "tier": "tier1"<br>  }<br>]</pre> | no |
| <a name="input_powervs_workspace_name"></a> [powervs\_workspace\_name](#input\_powervs\_workspace\_name) | Name of the PowerVS Workspace to create | `string` | n/a | yes |
| <a name="input_powervs_zone"></a> [powervs\_zone](#input\_powervs\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Existing IBM Cloud resource group name. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_instance_mgmt_ip"></a> [instance\_mgmt\_ip](#output\_instance\_mgmt\_ip) | IP address of the management network interface of IBM PowerVS instance. |
| <a name="output_instance_private_ips"></a> [instance\_private\_ips](#output\_instance\_private\_ips) | All private IP addresses (as a list) of IBM PowerVS instance. |
| <a name="output_instance_private_ips_info"></a> [instance\_private\_ips\_info](#output\_instance\_private\_ips\_info) | Complete info about all private IP addresses of IBM PowerVS instance. |
| <a name="output_storage_configuration"></a> [storage\_configuration](#output\_storage\_configuration) | Storage configuration of PowerVS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
