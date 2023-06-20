# Module pi_instance
This module creates and configures a PowerVS instance. The instance can be created for different use cases like HANA, Netweaver etc based on the inputs provided like image, profile, storage etc.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3, < 1.6 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.52.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [ibm_pi_instance.instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_instance) | resource |
| [ibm_pi_volume.create_volume](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_volume) | resource |
| [ibm_pi_volume_attach.instance_volumes_attach](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_volume_attach) | resource |
| [ibm_pi_image.image_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_image) | data source |
| [ibm_pi_instance.instance_ips_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_instance) | data source |
| [ibm_pi_instance_ip.instance_mgmt_ip_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_instance_ip) | data source |
| [ibm_pi_key.key_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_key) | data source |
| [ibm_pi_network.pi_subnets_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_network) | data source |
| [ibm_resource_group.resource_group_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_group) | data source |
| [ibm_resource_instance.pi_workspace_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/resource_instance) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cpu_proc_type"></a> [pi\_cpu\_proc\_type](#input\_pi\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_instance_name"></a> [pi\_instance\_name](#input\_pi\_instance\_name) | Name of instance which will be created | `string` | n/a | yes |
| <a name="input_pi_memory_size"></a> [pi\_memory\_size](#input\_pi\_memory\_size) | Amount of memory. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_networks"></a> [pi\_networks](#input\_pi\_networks) | Existing list of subnets name to be attached to an instance. First network has to be a management network | `list(any)` | n/a | yes |
| <a name="input_pi_number_of_processors"></a> [pi\_number\_of\_processors](#input\_pi\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. Conflicts with pi\_sap\_profile\_id | `string` | `null` | no |
| <a name="input_pi_os_image_name"></a> [pi\_os\_image\_name](#input\_pi\_os\_image\_name) | Image Name for PowerVS Instance | `string` | n/a | yes |
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
