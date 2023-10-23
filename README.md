<!-- BEGIN MODULE HOOK -->

# IBM Power Virtual Server instance module

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-powervs-instance?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

## Summary
This root module automates and provisions an IBM® Power Virtual Server instance with following components:

- Creates an IBM® Power Virtual Server Instance.
- Attaches **existing private subnets** to the instance.
- Optionally creates volumes and attaches it to the instance.
- Optional instance initialization for **ibm provided subscription linux images only** ( configures proxy settings, creates filesystems, connects to network management services like DNS, NTP and NFS) using ansible galaxy collection roles [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/). Tested with RHEL8.4, RHEL 8.6, SLES15-SP4 and SLES15-SP6 images.

For more information about IBM Power Virtual Server see the [getting started](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started) IBM Cloud docs.

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-powervs-instance](#terraform-ibm-powervs-instance)
* [Submodules](./modules)
    * [pi-instance-init-linux](./modules/pi-instance-init-linux)
    * [pi-instance](./modules/pi-instance)
    * [remote-exec-ansible](./modules/remote-exec-ansible)
    * [remote-exec-shell](./modules/remote-exec-shell)
* [Examples](./examples)
    * [Basic Power Virtual Server infrastructure with a Power Virtual Server instance](./examples/default)
    * [Basic Power Virtual Server instance with linux OS initialization](./examples/single-instance-linux)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## terraform-ibm-powervs-instance

### Usage

```hcl
provider "ibm" {
  region           = var.pi_region
  zone             = var.pi_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

module "pi_instance" {
    source     = "terraform-ibm-modules/powervs-instance/ibm"
    version    = "x.x.x" # Replace "x.x.x" with a GIT release version to lock into a specific release

    pi_workspace_guid          = var.pi_workspace_guid
    pi_ssh_public_key_name     = var.pi_ssh_public_key_name
    pi_image_id                = var.pi_image_id
    pi_networks                = var.pi_networks
    pi_instance_name           = var.pi_instance_name
    pi_sap_profile_id          = var.pi_sap_profile_id           #(optional, default ush1-4x128)
    pi_server_type             = var.pi_server_type              #(optional, default null)
    pi_number_of_processors    = var.pi_number_of_processors     #(optional, default null)
    pi_memory_size             = var.pi_memory_size              #(optional, default null)
    pi_cpu_proc_type           = var.pi_cpu_proc_type            #(optional, default check vars)
    pi_storage_config          = var.pi_storage_config           #(optional, default check vars)
    pi_instance_init_linux     = var.pi_instance_init_linux      #(optional, default check vars)
    pi_network_services_config = var.pi_network_services_config  #(optional, default check vars)
}
```

## Required IAM access policies

You need the following permissions to run this module.

- Account Management
    - **Resource Group** service
        - `Viewer` platform access
    - IAM Services
        - **Workspace for Power Virtual Server** service
        - **Power Virtual Server** service
            - `Editor` platform access
        - **VPC Infrastructure Services** service
            - `Editor` platform access
        - **Transit Gateway** service
            - `Editor` platform access
        - **Direct Link** service
            - `Editor` platform access

<!-- END MODULE HOOK -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pi_instance"></a> [pi\_instance](#module\_pi\_instance) | ./modules/pi-instance | n/a |
| <a name="module_pi_instance_init_linux"></a> [pi\_instance\_init\_linux](#module\_pi\_instance\_init\_linux) | ./modules/pi-instance-init-linux | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cpu_proc_type"></a> [pi\_cpu\_proc\_type](#input\_pi\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_image_id"></a> [pi\_image\_id](#input\_pi\_image\_id) | Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images. | `string` | n/a | yes |
| <a name="input_pi_instance_init_linux"></a> [pi\_instance\_init\_linux](#input\_pi\_instance\_init\_linux) | Configures a PowerVS linux instance to have internet access by setting proxy on it, updates os and create filesystems using ansible collection [ibm.power\_linux\_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/). where 'proxy\_host\_or\_ip\_port' E.g., 10.10.10.4:3128 <ip:port>, 'bastion\_host\_ip' is public IP of bastion/jump host to access the private IP of created linux PowerVS instance. | <pre>object(<br>    {<br>      enable                = bool<br>      bastion_host_ip       = string<br>      ssh_private_key       = string<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | <pre>{<br>  "bastion_host_ip": "",<br>  "enable": false,<br>  "no_proxy_hosts": "161.0.0.0/8,10.0.0.0/8",<br>  "proxy_host_or_ip_port": "",<br>  "ssh_private_key": ""<br>}</pre> | no |
| <a name="input_pi_instance_name"></a> [pi\_instance\_name](#input\_pi\_instance\_name) | Name of instance which will be created. | `string` | n/a | yes |
| <a name="input_pi_memory_size"></a> [pi\_memory\_size](#input\_pi\_memory\_size) | Amount of memory. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_network_services_config"></a> [pi\_network\_services\_config](#input\_pi\_network\_services\_config) | Configures network services NTP, NFS and DNS on PowerVS instance. Requires 'pi\_instance\_init\_linux' to be specified as internet access is required to download ansible collection [ibm.power\_linux\_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) to configure these services. | <pre>object(<br>    {<br>      nfs = object({ enable = bool, nfs_server_path = string, nfs_client_path = string })<br>      dns = object({ enable = bool, dns_server_ip = string })<br>      ntp = object({ enable = bool, ntp_server_ip = string })<br>    }<br>  )</pre> | <pre>{<br>  "dns": {<br>    "dns_server_ip": "",<br>    "enable": false<br>  },<br>  "nfs": {<br>    "enable": false,<br>    "nfs_client_path": "",<br>    "nfs_server_path": ""<br>  },<br>  "ntp": {<br>    "enable": false,<br>    "ntp_server_ip": ""<br>  }<br>}</pre> | no |
| <a name="input_pi_networks"></a> [pi\_networks](#input\_pi\_networks) | Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. Run 'ibmcloud pi networks' to list available private subnets. | <pre>list(<br>    object({<br>      name = string<br>      id   = string<br>      cidr = optional(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_pi_number_of_processors"></a> [pi\_number\_of\_processors](#input\_pi\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_sap_profile_id"></a> [pi\_sap\_profile\_id](#input\_pi\_sap\_profile\_id) | SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi\_server\_type, pi\_cpu\_proc\_type, pi\_number\_of\_processors and pi\_memory\_size will not be taken into account. | `string` | `"ush1-4x128"` | no |
| <a name="input_pi_server_type"></a> [pi\_server\_type](#input\_pi\_server\_type) | Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_ssh_public_key_name"></a> [pi\_ssh\_public\_key\_name](#input\_pi\_ssh\_public\_key\_name) | Existing PowerVS SSH Public key name. Run 'ibmcloud pi keys' to list available keys. | `string` | n/a | yes |
| <a name="input_pi_storage_config"></a> [pi\_storage\_config](#input\_pi\_storage\_config) | File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | <pre>[<br>  {<br>    "count": "2",<br>    "mount": "/data",<br>    "name": "data",<br>    "size": "100",<br>    "tier": "tier1"<br>  }<br>]</pre> | no |
| <a name="input_pi_workspace_guid"></a> [pi\_workspace\_guid](#input\_pi\_workspace\_guid) | Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_instance_primary_ip"></a> [pi\_instance\_primary\_ip](#output\_pi\_instance\_primary\_ip) | IP address of the primary network interface of IBM PowerVS instance. |
| <a name="output_pi_instance_private_ips"></a> [pi\_instance\_private\_ips](#output\_pi\_instance\_private\_ips) | All private IP addresses (as a list) of IBM PowerVS instance. |
| <a name="output_pi_storage_configuration"></a> [pi\_storage\_configuration](#output\_pi\_storage\_configuration) | Storage configuration of PowerVS instance. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
