variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
  default     = null
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  default     = "lon06"
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "tok04", "us-east", "us-south", "dal12", "dal13", "tor01", "osa21", "sao01", "sao04", "mon01", "wdc04", "wdc06", "wdc07"], var.powervs_zone)
    error_message = "Only Following DC values are supported :  syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, tok04, us-east, us-south, dal12, dal13, tor01, osa21, sao01, sao04, mon01, wdc04, wdc06, wdc07"
  }
}

#####################################################
# PowerVS Infrastructure Parameters
#####################################################

variable "resource_group" {
  type        = string
  description = "Existing IBM Cloud resource group name. If null, a new resource group will be created."
  default     = null
}

variable "prefix" {
  description = "Prefix for resources which will be created."
  type        = string
  default     = "pi"
}

variable "powervs_workspace_name" {
  description = "Name of the PowerVS Workspace to create"
  type        = string
  default     = "power-workspace"
}

variable "powervs_sshkey_name" {
  description = "Name of the PowerVS SSH key to create"
  type        = string
  default     = "ssh-key-pvs"
}

variable "powervs_management_network" {
  description = "Name of the IBM Cloud PowerVS management subnet and CIDR to create"
  type = object({
    name = string
    cidr = string
  })
  default = {
    name = "mgmt_net"
    cidr = "10.51.0.0/24"
  }
}

variable "powervs_backup_network" {
  description = "Name of the IBM Cloud PowerVS backup network and CIDR to create"
  type = object({
    name = string
    cidr = string
  })
  default = {
    name = "bkp_net"
    cidr = "10.52.0.0/24"
  }
}

variable "transit_gateway_name" {
  description = "Name of the existing transit gateway. Required when you create new IBM Cloud connections."
  type        = string
  default     = null
}

variable "cloud_connection" {
  description = "Cloud connection configuration: speed (50, 100, 200, 500, 1000, 2000, 5000, 10000 Mb/s), count (1 or 2 connections), global_routing (true or false), metered (true or false)"
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
  description = "Name of instance which will be created"
  type        = string
  default     = "pi"
}

variable "powervs_os_image_name" {
  description = "Image Name for PowerVS Instance"
  type        = string
  default     = "RHEL8-SP4-SAP"
}

variable "powervs_sap_profile_id" {
  description = "SAP Profile ID for the amount of cores and memory. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). Required only when creating SAP instances. If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account"
  type        = string
  default     = "ush1-4x128"
}

variable "powervs_server_type" {
  description = "Processor type e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with pi_sap_profile_id"
  type        = string
  default     = null
}

variable "powervs_cpu_proc_type" {
  description = "Dedicated or shared processors. Required when not creating SAP instances. Conflicts with pi_sap_profile_id"
  type        = string
  default     = null
}

variable "powervs_number_of_processors" {
  description = "Number of processors. Required when not creating SAP instances. Conflicts with pi_sap_profile_id"
  type        = string
  default     = null
}

variable "powervs_memory_size" {
  description = "Amount of memory. Required when not creating SAP instances. Conflicts with pi_sap_profile_id"
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

variable "pi_instance_init" {
  description = "Setup Proxy client and create filesystems on OS. Supported for LINUX distribution only."
  type = object({
    enable            = bool
    access_host_or_ip = string
    ssh_private_key   = string
  })
  default = {
    enable            = false
    access_host_or_ip = ""
    ssh_private_key   = ""
  }
}
