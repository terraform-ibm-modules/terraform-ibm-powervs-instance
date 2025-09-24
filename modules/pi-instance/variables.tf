variable "pi_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "pi_ssh_public_key_name" {
  description = "Existing PowerVS SSH Public key name. Run 'ibmcloud pi keys' to list available keys."
  type        = string
}

variable "pi_instance_name" {
  description = "Name of instance which will be created."
  type        = string
}

variable "pi_boot_image_id" {
  description = "Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images."
  type        = string
}

variable "pi_boot_image_storage_pool" {
  description = "Storage Pool for server deployment; Only valid when you deploy one of the IBM supplied stock images. Storage pool for a custom image (an imported image or an image that is created from a VM capture) defaults to the storage pool the image was created in."
  type        = string
}

variable "pi_boot_image_storage_tier" {
  description = "Storage type for server deployment. If storage type is not provided the storage type will default to tier3."
  type        = string
}

variable "pi_networks" {
  description = "Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. Run 'ibmcloud pi networks' to list available private subnets."
  type = list(
    object({
      name = string
      id   = string
      cidr = optional(string)
      ip   = optional(string)
    })
  )
}

variable "pi_sap_profile_id" {
  description = "SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account"
  type        = string
}

variable "pi_server_type" {
  description = "The type of system on which to create the VM. Supported values are e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
}

variable "pi_deployment_target" {
  description = "The deployment of a dedicated host. Max items: 1, id is the uuid of the host group or host. type is the deployment target type, supported values are host and hostGroup"
  type = list(object(
    {
      type = string
      id   = string
    }
  ))
}

variable "pi_cpu_proc_type" {
  description = "The type of processor mode in which the VM will run with shared, capped or dedicated. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
}

variable "pi_number_of_processors" {
  description = "The number of vCPUs to assign to the VM as visible within the guest Operating System. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
}

variable "pi_license_repository_capacity" {
  description = "The VTL license repository capacity as TB value. Only use with VTL instances."
  type        = number
}

variable "pi_memory_size" {
  description = "The amount of memory that you want to assign to your instance in GB. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
}

variable "pi_replicants" {
  description = "The number of instances that you want to provision with the same configuration. If this parameter is not set, 1 is used by default. The replication policy that you want to use, either affinity, anti-affinity or none. If this parameter is not set, none is used by default. pi_placement_group_id cannot be used when specifying pi_replicants"
  type = object({
    count  = number
    policy = string
  })
}

variable "pi_affinity_policy" {
  description = "Specifies the affinity policy for the PVM instance. Allowed values: 'affinity' or 'anti-affinity'. If set to 'affinity', provide the 'pi_affinity' input. If set to 'anti-affinity', provide the 'pi_anti_affinity' input. This policy will be ignored if 'pi_boot_image_storage_pool' is specified."
  type        = string
}

variable "pi_affinity" {
  description = "Defines affinity settings for instances or volumes. If requesting affinity, either 'affinity_instance' or 'affinity_volume' must be provided. 'affinity_instance' specifies the name of the target PVM instance, while 'affinity_volume' designates a volume to establish storage affinity."
  type = object({
    affinity_instance = string
    affinity_volume   = string
  })
}

variable "pi_anti_affinity" {
  description = "Defines anti-affinity settings for instances or volumes. If requesting anti-affinity, either 'anti_affinity_instances' or 'anti_affinity_volumes' must be provided. 'anti_affinity_instances' is a list of PVM instance names to enforce anti-affinity, while 'anti_affinity_volumes' is a list of volumes to apply the storage anti-affinity policy."
  type = object({
    anti_affinity_instances = list(string)
    anti_affinity_volumes   = list(string)
  })
}

variable "pi_placement_group_id" {
  description = "The ID of the placement group that the instance is in or empty quotes '' to indicate it is not in a placement group. pi_replicants cannot be used when specifying a placement group ID."
  type        = string
}

variable "pi_storage_config" {
  description = "Storage volumes to be created and attached to PowerVS instance. List of objects. 'size' is in GB. 'count' specify how many storage volumes of the same type are created. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS (only if pi_instance_init_linux is enabled). 'pool' specifies the volume pool where the volume will be created. 'sharable' specifies if volume can be shared across PVM instances. If pi_instance_init_linux is enabled, all disks in one object are combined into one logical volume, a filesystem is created and mounted on the OS. If using AIX, disks are only created and attached to the PowerVS instance."
  type = list(object({
    name     = string
    size     = string
    count    = string
    tier     = string
    mount    = optional(string)
    pool     = optional(string)
    sharable = optional(bool)
  }))
}

variable "pi_existing_volume_ids" {
  description = "List of existing volume ids that must be attached to the instance."
  type        = list(string)
}

variable "pi_user_tags" {
  description = "List of Tag names for IBM Cloud PowerVS instance and volumes. Can be set to null."
  type        = list(string)
}

variable "pi_user_data" {
  description = "The user data cloud-init to pass to the instance during creation. It can be a base64 encoded or an unencoded string. If it is an unencoded string, the provider will encode it before it passing it down."
  type        = string
}
variable "pi_pin_policy" {
  description = "Specifies the pinning policy for the PowerVS instance. Valid values: 'soft', 'hard', or 'none'. 'soft' allows auto-migration back to the original host, 'hard' restricts host movement, and 'none' applies no pinning. Default is 'none'."
  type        = string
  default     = null
}
