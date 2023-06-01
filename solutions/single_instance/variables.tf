variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources."
  type        = string
  sensitive   = true
  default     = null
}

variable "powervs_zone" {
  description = "IBM Cloud PowerVS zone."
  type        = string
}

variable "resource_group_name" {
  type        = string
  description = "Existing IBM Cloud resource group name."
}

variable "powervs_workspace_name" {
  description = "Name of the PowerVS Workspace to create"
  type        = string
}

variable "powervs_sshkey_name" {
  description = "Name of the PowerVS SSH key to create"
  type        = string
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
  description = "SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then powervs_server_type, powervs_cpu_proc_type, powervs_number_of_processors and powervs_memory_size will not be taken into account"
  type        = string
  default     = "ush1-4x128"
}

variable "powervs_networks" {
  description = "Existing list of subnets name to be attached to an instance. First network has to be a management network."
  type        = list(any)
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

variable "powervs_instance_init" {
  description = "Setup Proxy client and create filesystems on OS. Supported for LINUX distribution only."
  type = object({
    enable            = bool
    access_host_or_ip = string
    ssh_private_key   = string
  })
}

variable "powervs_proxy_settings" {
  description = "Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port>"
  type = object(
    {
      proxy_host_or_ip_port = string
      no_proxy_hosts        = string
    }
  )
  default = {
    proxy_host_or_ip_port = ""
    no_proxy_hosts        = "161.0.0.0/8,10.0.0.0/8"
  }
}
