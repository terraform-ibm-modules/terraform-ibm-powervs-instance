variable "pi_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "pi_ssh_public_key_name" {
  description = "Existing PowerVS SSH Public key name. Run 'ibmcloud pi keys' to list available keys."
  type        = string
}

variable "pi_instance_name" {
  description = "Name of instance which will be created"
  type        = string
  validation {
    condition     = length(var.pi_instance_name) <= 13
    error_message = "Maximum length of Instance name must be less or equal to 13 characters only."
  }
}

variable "pi_image_id" {
  description = "Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images."
  type        = string
}

variable "pi_networks" {
  description = "Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface. Run 'ibmcloud pi networks' to list available private subnets."
  type = list(
    object({
      name = string
      id   = string
      cidr = optional(string)
    })
  )
}

variable "pi_sap_profile_id" {
  description = "SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account"
  type        = string
  default     = "ush1-4x128"
}

variable "pi_server_type" {
  description = "Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_cpu_proc_type" {
  description = "Dedicated or shared processors. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_number_of_processors" {
  description = "Number of processors. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_memory_size" {
  description = "Amount of memory. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_replicants" {
  description = "The number of instances that you want to provision with the same configuration. If this parameter is not set, 1 is used by default. The replication policy that you want to use, either affinity, anti-affinity or none. If this parameter is not set, none is used by default. pi_placement_group_id cannot be used when specifying pi_replicants"
  type = object({
    count  = number
    policy = string
  })
  default = null
}

variable "pi_placement_group_id" {
  description = "The ID of the placement group that the instance is in or empty quotes '' to indicate it is not in a placement group. pi_replicants cannot be used when specifying a placement group ID."
  type        = string
  default     = null

}

variable "pi_boot_image_storage_pool" {
  description = "Storage Pool for server deployment; Only valid when you deploy one of the IBM supplied stock images. Storage pool for a custom image (an imported image or an image that is created from a VM capture) defaults to the storage pool the image was created in."
  type        = string
  default     = null
}

variable "pi_boot_image_storage_tier" {
  description = "Storage type for server deployment; If storage type is not provided the storage type will default to tier3."
  type        = string
}

variable "pi_storage_config" {
  description = "File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS."
  type = list(object({
    name  = string
    size  = string
    count = string
    tier  = string
    mount = string
  }))

  validation {
    condition = var.pi_storage_config != null ? (
      alltrue([for config in var.pi_storage_config : (
        (config.name != "" && config.count != "" && config.tier != "" && config.mount != "") || (config.name == "" && config.count == "" && config.tier == "" && config.mount == "")
      )])
    ) : var.pi_storage_config == null ? true : false
    error_message = "One of the storage config has invalid value, probably an empty string'"
  }

}

variable "pi_existing_volume_ids" {
  description = "List of exisiting volume ids that must be attached to the instance."
  type        = list(string)
  default     = null
}
