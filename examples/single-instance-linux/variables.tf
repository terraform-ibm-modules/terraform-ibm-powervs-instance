variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
  validation {
    condition     = contains(["syd04", "syd05", "eu-de-1", "eu-de-2", "lon04", "lon06", "tok04", "us-east", "us-south", "dal10", "dal12", "tor01", "osa21", "sao01", "sao04", "mon01", "wdc04", "wdc06", "wdc07"], var.powervs_zone)
    error_message = "Only Following DC values are supported :  syd04, syd05, eu-de-1, eu-de-2, lon04, lon06, tok04, us-east, us-south, dal10, dal12, tor01, osa21, sao01, sao04, mon01, wdc04, wdc06, wdc07"
  }
}

variable "powervs_workspace_guid" {
  description = "Existing GUID of the PowerVS workspace. The GUID of the service instance associated with an account."
  type        = string
}

variable "powervs_ssh_public_key_name" {
  description = "Name of the PowerVS SSH key to create."
  type        = string
}

#####################################################
# PowerVS Instance Parameters
#####################################################

variable "powervs_instance_name" {
  description = "Name of instance which will be created."
  type        = string
}

variable "powervs_image_id" {
  description = "Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images."
  type        = string
}

variable "powervs_boot_image_storage_tier" {
  description = "Storage type for server deployment. If storage type is not provided the storage type will default to tier3. Possible values tier0, tier1 and tier3"
  type        = string
  default     = null
}

variable "powervs_sap_profile_id" {
  description = "SAP Profile ID for the amount of cores and memory. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). Required only when creating SAP instances. If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account."
  type        = string
  default     = "ush1-4x128"
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

variable "powervs_placement_group_id" {
  description = "The ID of the placement group that the instance is in or empty quotes '' to indicate it is not in a placement group. pi_replicants cannot be used when specifying a placement group ID."
  type        = string
  default     = null
}

variable "powervs_networks" {
  description = "Existing list of private subnet ids to be attached to an instance. The first element will become the primary interface."
  type = list(
    object({
      name = string
      id   = string
      cidr = optional(string)
    })
  )
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

variable "powervs_existing_volume_ids" {
  description = "List of existing volume ids that must be attached to the instance."
  type        = list(string)
  default     = null
}

#####################################################
# PowerVS Instance Initialization Optional parameters.
#####################################################

variable "powervs_instance_init_linux" {
  description = "Configures a PowerVS linux instance to have internet access by setting proxy on it, updates os and create filesystems using ansible collection [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/). where 'proxy_host_or_ip_port' E.g., 10.10.10.4:3128 <ip:port>, 'bastion_host_ip' is public IP of bastion/jump host to access the private IP of created linux PowerVS instance."
  sensitive   = true
  type = object(
    {
      enable             = bool
      bastion_host_ip    = string
      ansible_host_or_ip = string
      ssh_private_key    = string
    }
  )

  default = {
    enable             = false
    bastion_host_ip    = ""
    ansible_host_or_ip = ""
    ssh_private_key    = <<-EOF
EOF
  }

}

variable "powervs_network_services_config" {
  description = "Configures network services NTP, NFS and DNS on PowerVS instance. Requires 'powervs_instance_init_linux' to be specified as internet access is required to download ansible collection [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) to configure these services. The 'opts' attribute can take in comma separated values."
  type = object(
    {
      squid = object({ enable = bool, squid_server_ip_port = string, no_proxy_hosts = string })
      nfs   = object({ enable = bool, nfs_server_path = string, nfs_client_path = string, opts = string, fstype = string })
      dns   = object({ enable = bool, dns_server_ip = string })
      ntp   = object({ enable = bool, ntp_server_ip = string })
    }
  )

  default = {
    squid = { enable = false, squid_server_ip_port = "", no_proxy_hosts = "" }
    nfs   = { enable = false, nfs_server_path = "", nfs_client_path = "", opts = "", fstype = "" }
    dns   = { enable = false, dns_server_ip = "" }
    ntp   = { enable = false, ntp_server_ip = "" }
  }

}
