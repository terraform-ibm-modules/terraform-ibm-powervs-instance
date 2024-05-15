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

variable "pi_image_id" {
  description = "Image ID used for PowerVS instance. Run 'ibmcloud pi images' to list available images."
  type        = string
}

variable "pi_boot_image_storage_pool" {
  description = "Storage Pool for server deployment; Only valid when you deploy one of the IBM supplied stock images. Storage pool for a custom image (an imported image or an image that is created from a VM capture) defaults to the storage pool the image was created in."
  type        = string
  default     = null
}

variable "pi_boot_image_storage_tier" {
  description = "Storage type for server deployment. If storage type is not provided the storage type will default to tier3. Possible values tier0, tier1 and tier3"
  type        = string
  default     = null
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
  description = "SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account."
  type        = string
  default     = null
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

variable "pi_storage_config" {
  description = "File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS."
  type = list(object({
    name  = string
    size  = string
    count = string
    tier  = string
    mount = string
    pool  = optional(string)
  }))

  default = null
}

variable "pi_existing_volume_ids" {
  description = "List of existing volume ids that must be attached to the instance."
  type        = list(string)
  default     = null
}

#####################################################
# PowerVS Instance Initialization
#####################################################

variable "pi_instance_init_linux" {
  description = "Configures a PowerVS linux instance to have internet access by setting proxy on it, updates os and create filesystems using ansible collection [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) where 'bastion_host_ip' is public IP of bastion/jump host to access the 'ansible_host_or_ip' private IP of ansible node. This ansible host must have access to the power virtual server instance and ansible host OS must be RHEL distribution."
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

  validation {
    condition     = var.pi_instance_init_linux != null ? var.pi_instance_init_linux.enable ? var.pi_instance_init_linux.bastion_host_ip != "" && var.pi_instance_init_linux.bastion_host_ip != null && var.pi_instance_init_linux.ssh_private_key != "" && var.pi_instance_init_linux.ssh_private_key != null ? true : false : true : true
    error_message = "If 'enable' is true, then 'ssh_private_key' attributes of 'pi_instance_init_linux' must be provided."
  }
}

variable "pi_network_services_config" {
  description = "Configures network services proxy, NTP, NFS and DNS on PowerVS instance. Requires 'pi_instance_init_linux' to be specified to configure these services."
  type = object(
    {
      squid = object({ enable = bool, squid_server_ip_port = string, no_proxy_hosts = string })
      nfs   = object({ enable = bool, nfs_server_path = string, nfs_client_path = string })
      dns   = object({ enable = bool, dns_server_ip = string })
      ntp   = object({ enable = bool, ntp_server_ip = string })
    }
  )

  default = {
    squid = { enable = false, squid_server_ip_port = "", no_proxy_hosts = "" }
    nfs   = { enable = false, nfs_server_path = "", nfs_client_path = "" }
    dns   = { enable = false, dns_server_ip = "" }
    ntp   = { enable = false, ntp_server_ip = "" }
  }

}
