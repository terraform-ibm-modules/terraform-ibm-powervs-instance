<!-- BEGIN MODULE HOOK -->

# IBM Power Virtual Server instance module

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![build status](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance/actions/workflows/ci.yml/badge.svg)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance/actions/workflows/ci.yml)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-powervs-instance?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance/releases/latest)

The PowerVS instance module automates the following tasks:

- Creates an IBM® Power Virtual Server Instance.
- Creates Volumes and Attaches it to the instance.
- Attaches existing private subnets to the instance.

For more information about IBM Power Virtual Server see the [getting started](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started) IBM Cloud docs.

## Usage
```hcl
provider "ibm" {
  region           = var.pi_region
  zone             = var.pi_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

module "pi_instance" {
  # Replace "main" with a GIT release version to lock into a specific release
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance.git?ref=main"

  pi_zone                 = var.pi_zone
  pi_resource_group_name  = var.pi_resource_group_name
  pi_workspace_name       = var.pi_workspace_name
  pi_sshkey_name          = var.pi_sshkey_name
  pi_instance_name        = var.pi_instance_name
  pi_os_image_name        = var.pi_os_image_name
  pi_networks             = var.pi_networks
  pi_sap_profile_id       = var.pi_sap_profile_id
  pi_server_type          = var.pi_server_type
  pi_cpu_proc_type        = var.pi_cpu_proc_type
  pi_number_of_processors = var.pi_number_of_processors
  pi_memory_size          = var.pi_memory_size
  pi_storage_config       = var.pi_storage_config
  pi_instance_init        = var.pi_instance_init
  pi_proxy_settings       = var.pi_proxy_settings

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
<!-- BEGIN EXAMPLES HOOK -->
## Solutions

- [ Basic Power Virtual Server Module Example](solutions/single_instance)
<!-- END EXAMPLES HOOK -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.5 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pi_instance"></a> [pi\_instance](#module\_pi\_instance) | ./submodules/pi_instance | n/a |
| <a name="module_pi_instance_init"></a> [pi\_instance\_init](#module\_pi\_instance\_init) | ./submodules/pi_instance_init | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cpu_proc_type"></a> [pi\_cpu\_proc\_type](#input\_pi\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_instance_init"></a> [pi\_instance\_init](#input\_pi\_instance\_init) | Setup Proxy client and create filesystems on OS. Supported for LINUX distribution only. 'access\_host\_or\_ip' Public IP of Bastion Host | <pre>object({<br>    enable            = bool<br>    access_host_or_ip = string<br>    ssh_private_key   = string<br>  })</pre> | n/a | yes |
| <a name="input_pi_instance_name"></a> [pi\_instance\_name](#input\_pi\_instance\_name) | Name of instance which will be created | `string` | n/a | yes |
| <a name="input_pi_memory_size"></a> [pi\_memory\_size](#input\_pi\_memory\_size) | Amount of memory. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_networks"></a> [pi\_networks](#input\_pi\_networks) | Existing list of subnets name to be attached to an instance. First network has to be a management network | `list(any)` | n/a | yes |
| <a name="input_pi_number_of_processors"></a> [pi\_number\_of\_processors](#input\_pi\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_os_image_name"></a> [pi\_os\_image\_name](#input\_pi\_os\_image\_name) | Image Name for PowerVS Instance | `string` | n/a | yes |
| <a name="input_pi_proxy_settings"></a> [pi\_proxy\_settings](#input\_pi\_proxy\_settings) | Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port> | <pre>object(<br>    {<br>      proxy_host_or_ip_port = string<br>      no_proxy_hosts        = string<br>    }<br>  )</pre> | <pre>{<br>  "no_proxy_hosts": "161.0.0.0/8,10.0.0.0/8",<br>  "proxy_host_or_ip_port": ""<br>}</pre> | no |
| <a name="input_pi_resource_group_name"></a> [pi\_resource\_group\_name](#input\_pi\_resource\_group\_name) | Existing IBM Cloud resource group name | `string` | n/a | yes |
| <a name="input_pi_sap_profile_id"></a> [pi\_sap\_profile\_id](#input\_pi\_sap\_profile\_id) | SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi\_server\_type, pi\_cpu\_proc\_type, pi\_number\_of\_processors and pi\_memory\_size will not be taken into account | `string` | `"ush1-4x128"` | no |
| <a name="input_pi_server_type"></a> [pi\_server\_type](#input\_pi\_server\_type) | Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_sshkey_name"></a> [pi\_sshkey\_name](#input\_pi\_sshkey\_name) | Existing PowerVs SSH key name | `string` | n/a | yes |
| <a name="input_pi_storage_config"></a> [pi\_storage\_config](#input\_pi\_storage\_config) | File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | <pre>[<br>  {<br>    "count": "2",<br>    "mount": "/data",<br>    "name": "data",<br>    "size": "100",<br>    "tier": "tier1"<br>  }<br>]</pre> | no |
| <a name="input_pi_workspace_name"></a> [pi\_workspace\_name](#input\_pi\_workspace\_name) | Existing Name of the PowerVS workspace | `string` | n/a | yes |
| <a name="input_pi_zone"></a> [pi\_zone](#input\_pi\_zone) | IBM Cloud PowerVS zone. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_instance_mgmt_ip"></a> [pi\_instance\_mgmt\_ip](#output\_pi\_instance\_mgmt\_ip) | IP address of the management network interface of IBM PowerVS instance. |
| <a name="output_pi_instance_private_ips"></a> [pi\_instance\_private\_ips](#output\_pi\_instance\_private\_ips) | All private IP addresses (as a list) of IBM PowerVS instance. |
| <a name="output_pi_instance_private_ips_info"></a> [pi\_instance\_private\_ips\_info](#output\_pi\_instance\_private\_ips\_info) | Complete info about all private IP addresses of IBM PowerVS instance. |
| <a name="output_pi_storage_configuration"></a> [pi\_storage\_configuration](#output\_pi\_storage\_configuration) | Storage configuration of PowerVS instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- BEGIN CONTRIBUTING HOOK -->

<!-- Leave this section as is so that your module has a link to local development environment set up steps for contributors to follow -->
## Contributing

You can report issues and request features for this module in GitHub issues in the module repo. See [Report an issue or request a feature](https://github.com/terraform-ibm-modules/.github/blob/main/.github/SUPPORT.md).

To set up your local development environment, see [Local development setup](https://terraform-ibm-modules.github.io/documentation/#/local-dev-setup) in the project documentation.
<!-- Source for this readme file: https://github.com/terraform-ibm-modules/common-dev-assets/tree/main/module-assets/ci/module-template-automation -->
<!-- END CONTRIBUTING HOOK -->
