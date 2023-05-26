variable "pi_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "tok04", "us-east", "us-south", "dal12", "dal13", "tor01", "osa21", "sao01", "sao04", "mon01", "wdc04", "wdc06", "wdc07"], var.pi_zone)
    error_message = "Only Following DC values are supported :  syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, tok04, us-east, us-south, dal12, dal13, tor01, osa21, sao01, sao04, mon01, wdc04, wdc06, wdc07"
  }
}

variable "pi_resource_group_name" {
  description = "Existing IBM Cloud resource group name."
  type        = string
}

variable "pi_workspace_name" {
  description = "Existing Name of the PowerVS workspace."
  type        = string
}

variable "pi_sshkey_name" {
  description = "Existing PowerVs SSH key name"
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

variable "pi_os_image_name" {
  description = "Image Name for PowerVS Instance"
  type        = string
}

variable "pi_boot_image_storage_tier" {
  description = "Storage tier for boot OS image. Supported values are 'tier1' and 'tier3'."
  type        = string
}

variable "pi_networks" {
  description = "Existing list of subnets name to be attached to an instance. First network has to be a management network."
  type        = list(any)
}

variable "pi_sap_profile_id" {
  description = "SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account"
  type        = string
  default     = "ush1-4x128"
}

variable "pi_server_type" {
  description = "Processor type e980/s922/e1080/s1022"
  type        = string
  default     = null
}

variable "pi_cpu_proc_type" {
  description = "Dedicated or shared processors"
  type        = string
  default     = null
}

variable "pi_number_of_processors" {
  description = "Number of processors"
  type        = string
  default     = null
}

variable "pi_memory_size" {
  description = "Amount of memory"
  type        = string
  default     = null
}

variable "pi_storage_config" {
  description = "Custom File systems to be created and attached to PowerVS instance for SAP HANA. 'disk_sizes' are in GB. 'count' specify over how many storage volumes the file system will be striped. 'tiers' specifies the storage tier in PowerVS workspace. For creating multiple file systems, specify multiple entries in each parameter in the structure. E.g., for creating 2 file systems, specify 2 names, 2 disk sizes, 2 counts, 2 tiers and 2 paths."
  type = object({
    names      = string
    disks_size = string
    counts     = string
    tiers      = string
    paths      = string
  })
  default = {
    names      = ""
    disks_size = ""
    counts     = ""
    tiers      = ""
    paths      = ""
  }
}
