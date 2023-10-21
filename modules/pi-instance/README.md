# Module pi-instance

This module provisions the following resources in IBM Cloud:

- Creates an IBM® Power Virtual Server (PowerVS) instance in an existing PowerVS workspace based on inputs provided like image id, profile etc.
- Creates volumes based on size and count provided.
- Attaches the volumes to the created PowerVS instance.

## Usage
```hcl
provider "ibm" {
region           = "sao"
zone             = "sao01"
ibmcloud_api_key = "your api key" != null ? "your api key" : null
}

module "powervs_instance" {
  source     = "terraform-ibm-modules/powervs-instance/ibm//modules//pi-instance"
  version    = "x.x.x" #replace x.x.x to lock to a specific version

  pi_workspace_guid       = var.pi_workspace_guid
  pi_ssh_public_key_name  = var.pi_ssh_public_key_name
  pi_image_id             = var.pi_image_id
  pi_networks             = var.pi_networks
  pi_instance_name        = var.pi_instance_name
  pi_sap_profile_id       = var.pi_sap_profile_id
  pi_server_type          = var.pi_server_type
  pi_number_of_processors = var.pi_number_of_processors
  pi_memory_size          = var.pi_memory_size
  pi_cpu_proc_type        = var.pi_cpu_proc_type
  pi_storage_config       = var.pi_storage_config
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_ibm"></a> [ibm](#requirement\_ibm) | >=1.49.0 |

### Modules

No modules.

### Resources

| Name | Type |
|------|------|
| [ibm_pi_instance.instance](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_instance) | resource |
| [ibm_pi_volume.create_volume](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_volume) | resource |
| [ibm_pi_volume_attach.instance_volumes_attach](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/resources/pi_volume_attach) | resource |
| [ibm_pi_instance.instance_ips_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_instance) | data source |
| [ibm_pi_instance_ip.instance_primary_ip_ds](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/data-sources/pi_instance_ip) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pi_cpu_proc_type"></a> [pi\_cpu\_proc\_type](#input\_pi\_cpu\_proc\_type) | Dedicated or shared processors. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_image_id"></a> [pi\_image\_id](#input\_pi\_image\_id) | Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images. | `string` | n/a | yes |
| <a name="input_pi_instance_name"></a> [pi\_instance\_name](#input\_pi\_instance\_name) | Name of instance which will be created | `string` | n/a | yes |
| <a name="input_pi_memory_size"></a> [pi\_memory\_size](#input\_pi\_memory\_size) | Amount of memory. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_networks"></a> [pi\_networks](#input\_pi\_networks) | Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. Run 'ibmcloud pi networks' to list available private subnets. | <pre>list(<br>    object({<br>      name = string<br>      id   = string<br>      cidr = optional(string)<br>    })<br>  )</pre> | n/a | yes |
| <a name="input_pi_number_of_processors"></a> [pi\_number\_of\_processors](#input\_pi\_number\_of\_processors) | Number of processors. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_sap_profile_id"></a> [pi\_sap\_profile\_id](#input\_pi\_sap\_profile\_id) | SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi\_server\_type, pi\_cpu\_proc\_type, pi\_number\_of\_processors and pi\_memory\_size will not be taken into account | `string` | `"ush1-4x128"` | no |
| <a name="input_pi_server_type"></a> [pi\_server\_type](#input\_pi\_server\_type) | Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi\_sap\_profile\_id'. | `string` | `null` | no |
| <a name="input_pi_ssh_public_key_name"></a> [pi\_ssh\_public\_key\_name](#input\_pi\_ssh\_public\_key\_name) | Existing PowerVS SSH Public key name. Run 'ibmcloud pi keys' to list available keys. | `string` | n/a | yes |
| <a name="input_pi_storage_config"></a> [pi\_storage\_config](#input\_pi\_storage\_config) | File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. | <pre>list(object({<br>    name  = string<br>    size  = string<br>    count = string<br>    tier  = string<br>    mount = string<br>  }))</pre> | n/a | yes |
| <a name="input_pi_workspace_guid"></a> [pi\_workspace\_guid](#input\_pi\_workspace\_guid) | Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account. | `string` | n/a | yes |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_pi_instance_primary_ip"></a> [pi\_instance\_primary\_ip](#output\_pi\_instance\_primary\_ip) | IP address of the primary network interface of IBM PowerVS instance. |
| <a name="output_pi_instance_private_ips"></a> [pi\_instance\_private\_ips](#output\_pi\_instance\_private\_ips) | All private IP addresses (as a list) of IBM PowerVS instance. |
| <a name="output_pi_storage_configuration"></a> [pi\_storage\_configuration](#output\_pi\_storage\_configuration) | Storage configuration of PowerVS instance |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
