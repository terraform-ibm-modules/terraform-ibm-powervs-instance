<!-- BEGIN MODULE HOOK -->

# IBM Power Virtual Server instance module

[![Graduated (Supported)](https://img.shields.io/badge/status-Graduated%20(Supported)-brightgreen?style=plastic)](https://terraform-ibm-modules.github.io/documentation/#/badge-status)
[![semantic-release](https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg)](https://github.com/semantic-release/semantic-release)
[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit&logoColor=white)](https://github.com/pre-commit/pre-commit)
[![latest release](https://img.shields.io/github/v/release/terraform-ibm-modules/terraform-ibm-powervs-instance?logo=GitHub&sort=semver)](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-instance/releases/latest)
[![Renovate enabled](https://img.shields.io/badge/renovate-enabled-brightgreen.svg)](https://renovatebot.com/)

<!-- BEGIN OVERVIEW HOOK -->
## Overview
* [terraform-ibm-powervs-instance](#terraform-ibm-powervs-instance)
* [Submodules](./modules)
    * [pi-instance](./modules/pi-instance)
* [Examples](./examples)
    * [Basic Power Virtual Server infrastructure with a Power Virtual Server instance](./examples/basic)
    * [Basic Power Virtual Server instance with linux OS initialization](./examples/single-instance-linux)
* [Contributing](#contributing)
<!-- END OVERVIEW HOOK -->

## Summary
This root module automates and provisions an IBM® Power Virtual Server instance with following components:

- Creates an IBM® Power Virtual Server Instance.
- Attaches **existing private subnets** to the instance.
- Optionally creates volumes and attaches it to the instance.
- Optionally attaches existing volume ids to the instance.
- Optional instance initialization for **ibm provided subscription linux images only** ( configures proxy settings, creates filesystems, connects to network management services like DNS, NTP and NFS) using ansible galaxy collection roles [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/). Tested with RHEL8.4, RHEL 8.6, RHEL8.8, RHEL9.2, RHEL9.4, SLES15-SP4, SLES15-SP5, SLES15-SP6 images.

For more information about IBM Power Virtual Server see the [getting started](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-getting-started) IBM Cloud docs.


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

    pi_workspace_guid               = var.pi_workspace_guid
    pi_ssh_public_key_name          = var.pi_ssh_public_key_name
    pi_image_id                     = var.pi_image_id
    pi_networks                     = var.pi_networks
    pi_instance_name                = var.pi_instance_name
    pi_pin_policy                   = var.pi_pin_policy               #(optional, default null)
    pi_sap_profile_id               = var.pi_sap_profile_id           #(optional, default null)
    pi_server_type                  = var.pi_server_type              #(optional, default null)
    pi_number_of_processors         = var.pi_number_of_processors     #(optional, default null)
    pi_memory_size                  = var.pi_memory_size              #(optional, default null)
    pi_cpu_proc_type                = var.pi_cpu_proc_type            #(optional, default check vars)
    pi_boot_image_storage_pool      = vat.pi_boot_image_storage_pool  #(optional, default null)
    pi_boot_image_storage_tier      = var.pi_boot_image_storage_tier  #(optional, default null)
    pi_replicants                   = var.pi_replicants               #(optional, default null)
    pi_placement_group_id           = var.pi_placement_group_id       #(optional, default null)
    pi_existing_volume_ids          = var.pi_existing_volume_ids      #(optional, default null)
    pi_affinity_policy              = var.pi_affinity_policy          #(optional, default null)
    pi_affinity                     = var.pi_affinity                 #(optional, default check vars)
    pi_anti_affinity                = var.pi_anti_affinity            #(optional, default check vars)
    pi_storage_config               = var.pi_storage_config           #(optional, default check vars)
    pi_user_tags                    = var.pi_user_tags                #(optional, default null)
    pi_user_data                    = var.pi_user_data                #(optional, default null)
    pi_license_repository_capacity  = var.pi_license_repository_capacity #(optional, default null)
    pi_instance_init_linux          = var.pi_instance_init_linux      #(optional, default check vars)
    pi_network_services_config      = var.pi_network_services_config  #(optional, default check vars)
    ansible_vault_password          = var.ansible_vault_password      #(optional, default null)
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >= 1.81.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_pi_instance"></a> [pi\_instance](#module\_pi\_instance) | ./modules/pi-instance | n/a |
| <a name="module_pi_instance_init_linux"></a> [pi\_instance\_init\_linux](#module\_pi\_instance\_init\_linux) | ./modules/ansible | n/a |

### Resources

No resources.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ansible_vault_password"></a> [ansible\_vault\_password](#input\_ansible\_vault\_password) | Vault password to encrypt OS registration parameters. Only required with customer provided linux subscription (specified in pi\_instance\_init\_linux.custom\_os\_registration). Password requirements: 15-100 characters and at least one uppercase letter, one lowercase letter, one number, and one special character. Allowed characters: A-Z, a-z, 0-9, !#$%&()*+-.:;<=>?@[]\_{\|}~. | `string` | `null` | no |
| <a name="input_pi_affinity"></a> [pi\_affinity](#input\_pi\_affinity) | Defines affinity settings for instances or volumes. If requesting affinity, set this object with either one of 'affinity\_instance' or 'affinity\_volume'. Otherwise value must be null. 'affinity\_instance' specifies the name of the target PVM instance, while 'affinity\_volume' designates a volume to establish storage affinity. | <pre>object({<br/>    affinity_instance = optional(string)<br/>    affinity_volume   = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_pi_affinity_policy"></a> [pi\_affinity\_policy](#input\_pi\_affinity\_policy) | Specifies the affinity policy for the PVM instance. Allowed values: 'affinity' or 'anti-affinity'. If set to 'affinity', provide the 'pi\_affinity' input. If set to 'anti-affinity', provide the 'pi\_anti\_affinity' input. This policy will be ignored if 'pi\_boot\_image\_storage\_pool' is specified. | `string` | `null` | no |
| <a name="input_pi_anti_affinity"></a> [pi\_anti\_affinity](#input\_pi\_anti\_affinity) | Defines anti-affinity settings for instances or volumes. If requesting anti-affinity, set this object with either one of 'anti\_affinity\_instances' or 'anti\_affinity\_volumes'. Otherwise value must be null. 'anti\_affinity\_instances' is a list of PVM instance names to enforce anti-affinity, while 'anti\_affinity\_volumes' is a list of volumes to apply the storage anti-affinity policy. | <pre>object({<br/>    anti_affinity_instances = optional(list(string))<br/>    anti_affinity_volumes   = optional(list(string))<br/>  })</pre> | `null` | no |
| <a name="input_pi_boot_image_storage_pool"></a> [pi\_boot\_image\_storage\_pool](#input\_pi\_boot\_image\_storage\_pool) | Storage Pool for server deployment; Only valid when you deploy one of the IBM supplied stock images. Storage pool for a custom image (an imported image or an image that is created from a VM capture) defaults to the storage pool the image was created in. | `string` | `null` | no |
| <a name="input_pi_boot_image_storage_tier"></a> [pi\_boot\_image\_storage\_tier](#input\_pi\_boot\_image\_storage\_tier) | Storage type for server deployment. If storage type is not provided the storage type will default to tier3. Possible values tier0, tier1 and tier3 | `string` | `null` | no |
| <a name="input_pi_cpu_proc_type"></a> [pi\_cpu\_proc\_type](#input\_pi\_cpu\_proc\_type) | The type of processor mode in which the VM will run with shared, capped or dedicated. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_existing_volume_ids"></a> [pi\_existing\_volume\_ids](#input\_pi\_existing\_volume\_ids) | List of existing volume ids that must be attached to the instance. | `list(string)` | `null` | no |
| <a name="input_pi_image_id"></a> [pi\_image\_id](#input\_pi\_image\_id) | Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images. | `string` | n/a | yes |
| <a name="input_pi_instance_init_linux"></a> [pi\_instance\_init\_linux](#input\_pi\_instance\_init\_linux) | Configures a PowerVS linux instance to have internet access by setting proxy on it, updates os and create filesystems using ansible collection [ibm.power\_linux\_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) where 'bastion\_host\_ip' is public IP of bastion/jump host to access the 'ansible\_host\_or\_ip' private IP of ansible node. Additionally, specify whether IBM provided or customer provided linux subscription should be used. For IBM provided subscription leave custom\_os\_registration empty. For customer provided subscription set a username and a password inside custom\_os\_registration. Customer provided linux subscription requires the use of either an IBM provided image ending in BYOL or a custom image. The ansible host must have access to the power virtual server instance and ansible host OS must be RHEL distribution. | <pre>object(<br/>    {<br/>      enable             = bool<br/>      bastion_host_ip    = string<br/>      ansible_host_or_ip = string<br/>      ssh_private_key    = string<br/>      custom_os_registration = optional(object({<br/>        username = string<br/>        password = string<br/>      }))<br/>    }<br/>  )</pre> | <pre>{<br/>  "ansible_host_or_ip": "",<br/>  "bastion_host_ip": "",<br/>  "enable": false,<br/>  "ssh_private_key": ""<br/>}</pre> | no |
| <a name="input_pi_instance_name"></a> [pi\_instance\_name](#input\_pi\_instance\_name) | Name of instance which will be created. | `string` | n/a | yes |
| <a name="input_pi_license_repository_capacity"></a> [pi\_license\_repository\_capacity](#input\_pi\_license\_repository\_capacity) | The VTL license repository capacity as TB value. Only use with VTL instances. | `number` | `null` | no |
| <a name="input_pi_memory_size"></a> [pi\_memory\_size](#input\_pi\_memory\_size) | The amount of memory that you want to assign to your instance in GB. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_network_services_config"></a> [pi\_network\_services\_config](#input\_pi\_network\_services\_config) | Configures network services proxy, NTP, NFS and DNS on PowerVS instance. Requires 'pi\_instance\_init\_linux' to be specified to configure these services. The 'opts' attribute can take in comma separated values. | <pre>object(<br/>    {<br/>      squid = object({ enable = bool, squid_server_ip_port = string, no_proxy_hosts = string })<br/>      nfs   = object({ enable = bool, nfs_server_path = string, nfs_client_path = string, opts = string, fstype = string })<br/>      dns   = object({ enable = bool, dns_server_ip = string })<br/>      ntp   = object({ enable = bool, ntp_server_ip = string })<br/>    }<br/>  )</pre> | <pre>{<br/>  "dns": {<br/>    "dns_server_ip": "",<br/>    "enable": false<br/>  },<br/>  "nfs": {<br/>    "enable": false,<br/>    "fstype": "",<br/>    "nfs_client_path": "",<br/>    "nfs_server_path": "",<br/>    "opts": ""<br/>  },<br/>  "ntp": {<br/>    "enable": false,<br/>    "ntp_server_ip": ""<br/>  },<br/>  "squid": {<br/>    "enable": false,<br/>    "no_proxy_hosts": "",<br/>    "squid_server_ip_port": ""<br/>  }<br/>}</pre> | no |
| <a name="input_pi_networks"></a> [pi\_networks](#input\_pi\_networks) | Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. Run 'ibmcloud pi networks' to list available private subnets. | <pre>list(<br/>    object({<br/>      name = string<br/>      id   = string<br/>      cidr = optional(string)<br/>      ip   = optional(string)<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_pi_number_of_processors"></a> [pi\_number\_of\_processors](#input\_pi\_number\_of\_processors) | The number of vCPUs to assign to the VM as visible within the guest Operating System. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_pin_policy"></a> [pi\_pin\_policy](#input\_pi\_pin\_policy) | Specifies the pinning policy for the PowerVS instance. Valid values: 'soft', 'hard', or 'none'. 'soft' allows auto-migration back to the original host, 'hard' restricts host movement, and 'none' applies no pinning. Default is 'none'. | `string` | `null` | no |
| <a name="input_pi_placement_group_id"></a> [pi\_placement\_group\_id](#input\_pi\_placement\_group\_id) | The ID of the placement group that the instance is in or empty quotes '' to indicate it is not in a placement group. pi\_replicants cannot be used when specifying a placement group ID. | `string` | `null` | no |
| <a name="input_pi_replicants"></a> [pi\_replicants](#input\_pi\_replicants) | The number of instances that you want to provision with the same configuration. If this parameter is not set, 1 is used by default. The replication policy that you want to use, either affinity, anti-affinity or none. If this parameter is not set, none is used by default. pi\_placement\_group\_id cannot be used when specifying pi\_replicants | <pre>object({<br/>    count  = number<br/>    policy = string<br/>  })</pre> | `null` | no |
| <a name="input_pi_sap_profile_id"></a> [pi\_sap\_profile\_id](#input\_pi\_sap\_profile\_id) | SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi\_server\_type, pi\_cpu\_proc\_type, pi\_number\_of\_processors and pi\_memory\_size will not be taken into account. | `string` | `null` | no |
| <a name="input_pi_server_type"></a> [pi\_server\_type](#input\_pi\_server\_type) | The type of system on which to create the VM. Supported values are e980/s922/s1022/e1050/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_ssh_public_key_name"></a> [pi\_ssh\_public\_key\_name](#input\_pi\_ssh\_public\_key\_name) | Existing PowerVS SSH Public key name. Run 'ibmcloud pi keys' to list available keys. | `string` | n/a | yes |
| <a name="input_pi_storage_config"></a> [pi\_storage\_config](#input\_pi\_storage\_config) | File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specifies the number of storage volumes to be created for the file system. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. 'pool' specifies the volume pool where the volume will be created. 'sharable' specifies if volume can be shared across PVM instances. | <pre>list(object({<br/>    name     = string<br/>    size     = string<br/>    count    = string<br/>    tier     = string<br/>    mount    = optional(string)<br/>    pool     = optional(string)<br/>    sharable = optional(bool)<br/>  }))</pre> | `null` | no |
| <a name="input_pi_user_data"></a> [pi\_user\_data](#input\_pi\_user\_data) | The user data cloud-init to pass to the instance during creation. It can be a base64 encoded or an unencoded string. If it is an unencoded string, the provider will encode it before it passing it down. | `string` | `null` | no |
| <a name="input_pi_user_tags"></a> [pi\_user\_tags](#input\_pi\_user\_tags) | List of Tag names for IBM Cloud PowerVS instance and volumes. Can be set to null. | `list(string)` | `null` | no |
| <a name="input_pi_workspace_guid"></a> [pi\_workspace\_guid](#input\_pi\_workspace\_guid) | Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_instance_id"></a> [pi\_instance\_id](#output\_pi\_instance\_id) | he unique identifier of the instance. The ID is composed of <power\_instance\_id>/<instance\_id>. |
| <a name="output_pi_instance_instance_id"></a> [pi\_instance\_instance\_id](#output\_pi\_instance\_instance\_id) | The unique identifier of PowerVS instance. |
| <a name="output_pi_instance_name"></a> [pi\_instance\_name](#output\_pi\_instance\_name) | Name of PowerVS instance. |
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
