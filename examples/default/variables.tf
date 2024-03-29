variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "tok04", "us-east", "us-south", "dal10", "dal12", "tor01", "osa21", "sao01", "sao04", "mon01", "wdc06", "wdc07"], var.powervs_zone)
    error_message = "Only Following DC values are supported :  syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, tok04, us-east, us-south, dal10, dal12, tor01, osa21, sao01, sao04, mon01, wdc06, wdc07"
  }
}

###########################################
# PowerVS Workspace module variables
############################################

variable "powervs_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision resources in to. If null, a new resource group will be created. using the prefix variable."
  default     = null
}

variable "prefix" {
  description = "Prefix for resources which will be created."
  type        = string
}

variable "powervs_workspace_name" {
  description = "Name of IBM Cloud PowerVS workspace which will be created."
  type        = string
  default     = "powervs-workspace"
}

variable "powervs_ssh_public_key" {
  description = "Value of the Public SSH key to create."
  type        = string
}

variable "powervs_private_subnet_1" {
  description = "IBM Cloud PowerVS first private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })
  default = {
    name = "sub_1"
    cidr = "10.51.0.0/24"
  }
}

variable "powervs_private_subnet_2" {
  description = "IBM Cloud PowerVS second private subnet name and cidr which will be created. Set value to null to not create this subnet."
  type = object({
    name = string
    cidr = string
  })
  default = {
    name = "sub_2"
    cidr = "10.53.0.0/24"
  }
}

variable "powervs_image_names" {
  description = "List of Images to be imported into cloud account from catalog images."
  type        = list(string)
  default     = ["SLES15-SP4-SAP", "RHEL8-SP6-SAP", "7300-01-01", "IBMi-75-01-2984-2"]
}

### Not creating cloud connections. Change count to enable
variable "powervs_cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false). Not applicable for PER enabled DC and CCs will not be created."
  type = object({
    count          = number
    speed          = number
    global_routing = bool
    metered        = bool
  })

  default = {
    count          = 0
    speed          = 5000
    global_routing = true
    metered        = true
  }
}

#####################################################
# PowerVS Instance Parameters
#####################################################

variable "powervs_instance_name" {
  description = "Name of instance which will be created."
  type        = string
  default     = "pi"
}

variable "powervs_os_image_name" {
  description = "Image Name for PowerVS Instance."
  type        = string
  default     = "RHEL8-SP6-SAP"
}

variable "powervs_sap_profile_id" {
  description = "SAP Profile ID for the amount of cores and memory. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). Required only when creating SAP instances. If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account."
  type        = string
  default     = "ush1-4x128"
}

variable "powervs_boot_image_storage_tier" {
  description = "Storage type for server deployment.Possible values tier0, tier1 and tier3"
  type        = string
  default     = "tier1"
}

variable "powervs_server_type" {
  description = "Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'powervs_sap_profile_id'."
  type        = string
  default     = null
}

variable "powervs_cpu_proc_type" {
  description = "Dedicated or shared processors. Required when not creating SAP instances. Conflicts with 'powervs_sap_profile_id'."
  type        = string
  default     = null
}

variable "powervs_number_of_processors" {
  description = "Number of processors. Required when not creating SAP instances. Conflicts with 'powervs_sap_profile_id'."
  type        = string
  default     = null
}

variable "powervs_memory_size" {
  description = "Amount of memory. Required when not creating SAP instances. Conflicts with 'powervs_sap_profile_id'."
  type        = string
  default     = null
}

variable "powervs_storage_config" {
  description = "Custom File systems to be created and attached to PowerVS instance. 'disk_size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace. 'mount' specifies the mount point on the OS."
  type = list(object({
    name  = string
    size  = string
    count = string
    tier  = string
    mount = string
  }))

  default = [
    {
      name = "data", size = "100", count = "2", tier = "tier1", mount = "/data"
    },
    {
      name = "log", size = "20", count = "2", tier = "tier3", mount = "/log"
    },
    {
      name = "shared", size = "20", count = "1", tier = "tier1", mount = "/shared"
    },
  ]
}
