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

  validation {
    condition     = length(var.pi_instance_name) <= 16
    error_message = "Maximum length of Instance name must be less or equal to 16 characters only."
  }
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
      ip   = optional(string)
    })
  )
}

variable "pi_sap_profile_id" {
  description = "SAP HANA profile to use. Must be one of the supported profiles. See [here](https://cloud.ibm.com/docs/sap?topic=sap-hana-iaas-offerings-profiles-power-vs). If this is mentioned then pi_server_type, pi_cpu_proc_type, pi_number_of_processors and pi_memory_size will not be taken into account."
  type        = string
  default     = null
}

variable "pi_server_type" {
  description = "The type of system on which to create the VM. Supported values are e980/s922/e1080/s1022. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null

  validation {
    condition     = var.pi_server_type == null ? true : contains(["e980", "s922", "e1080", "s1022"], var.pi_server_type) ? true : false
    error_message = "The system must be one of 'e980', 's922', 'e1080', or 's1022'."
  }
}

variable "pi_cpu_proc_type" {
  description = "The type of processor mode in which the VM will run with shared, capped or dedicated. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null

  validation {
    condition     = var.pi_cpu_proc_type == null ? true : contains(["shared", "capped", "dedicated"], var.pi_cpu_proc_type) ? true : false
    error_message = "The proc type must be one of 'shared', 'capped' or 'dedicated'."
  }

}

variable "pi_number_of_processors" {
  description = "The number of vCPUs to assign to the VM as visible within the guest Operating System. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
  type        = string
  default     = null
}

variable "pi_memory_size" {
  description = "The amount of memory that you want to assign to your instance in GB. Required when not creating SAP instances. Conflicts with 'pi_sap_profile_id'."
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

variable "pi_affinity_policy" {
  description = "Specifies the affinity policy for the PVM instance. Allowed values: 'affinity' or 'anti-affinity'. If set to 'affinity', provide the 'pi_affinity' input. If set to 'anti-affinity', provide the 'pi_anti_affinity' input. This policy will be ignored if 'pi_boot_image_storage_pool' is specified."
  type        = string
  default     = null

  validation {
    condition     = var.pi_affinity_policy == null || var.pi_affinity_policy == "affinity" || var.pi_affinity_policy == "anti-affinity"
    error_message = "Invalid value for pi_affinity_policy. Allowed values are 'null', 'affinity' or 'anti-affinity'."
  }
}

variable "pi_affinity" {
  description = "Defines affinity settings for instances or volumes. If requesting affinity, either 'affinity_instance' or 'affinity_volume' must be provided. 'affinity_instance' specifies the name of the target PVM instance, while 'affinity_volume' designates a volume to establish storage affinity."
  type = object({
    affinity_instance = optional(string)
    affinity_volume   = optional(string)
  })
  default = null
  validation {
    condition = var.pi_affinity == null || (
      (try(var.pi_affinity.affinity_instance, null) != null && try(var.pi_affinity.affinity_instance, "") != "" && try(var.pi_affinity.affinity_volume, null) == null) ||
      (try(var.pi_affinity.affinity_instance, null) == null && try(var.pi_affinity.affinity_volume, null) != null && try(var.pi_affinity.affinity_volume, "") != "")
    )
    error_message = "Invalid value for pi_affinity. Either one of 'affinity_instance' or 'affinity_volume' must be provided with non-empty value, but not both."
  }
}

variable "pi_anti_affinity" {
  description = "Defines anti-affinity settings for instances or volumes. If requesting anti-affinity, either 'anti_affinity_instances' or 'anti_affinity_volumes' must be provided. 'anti_affinity_instances' is a list of PVM instance names to enforce anti-affinity, while 'anti_affinity_volumes' is a list of volumes to apply the storage anti-affinity policy."
  type = object({
    anti_affinity_instances = optional(list(string))
    anti_affinity_volumes   = optional(list(string))
  })
  default = null
  validation {
    condition = var.pi_anti_affinity == null || (
      (try(var.pi_affinity.anti_affinity_instances, null) != null && length(try(var.pi_affinity.anti_affinity_instances, [])) > 0 && try(var.pi_affinity.anti_affinity_volumes, null) == null) ||
      (try(var.pi_affinity.anti_affinity_instances, null) == null && try(var.pi_affinity.anti_affinity_volumes, null) != null && length(try(var.pi_affinity.anti_affinity_volumes, [])) > 0)
    )
    error_message = "Invalid value for pi_anti_affinity. Either one of 'anti_affinity_instances' or 'anti_affinity_volumes' must be provided non-empty value, but not both."
  }
}

variable "pi_placement_group_id" {
  description = "The ID of the placement group that the instance is in or empty quotes '' to indicate it is not in a placement group. pi_replicants cannot be used when specifying a placement group ID."
  type        = string
  default     = null
}

variable "pi_storage_config" {
  description = "File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. 'pool' specifies the volume pool where the volume will be created. 'sharable' specifies if volume can be shared across PVM instances."
  type = list(object({
    name     = string
    size     = string
    count    = string
    tier     = string
    mount    = string
    pool     = optional(string)
    sharable = optional(bool)
  }))

  default = null

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
  description = "List of existing volume ids that must be attached to the instance."
  type        = list(string)
  default     = null
}

variable "pi_user_tags" {
  description = "List of Tag names for IBM Cloud PowerVS instance and volumes. Can be set to null."
  type        = list(string)
  default     = null
}

variable "pi_user_data" {
  description = "The user data cloud-init to pass to the instance during creation. It can be a base64 encoded or an unencoded string. If it is an unencoded string, the provider will encode it before it passing it down."
  type        = string
  default     = null
}

#####################################################
# PowerVS Instance Initialization
#####################################################

variable "pi_instance_init_linux" {
  description = "Configures a PowerVS linux instance to have internet access by setting proxy on it, updates os and create filesystems using ansible collection [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/) where 'bastion_host_ip' is public IP of bastion/jump host to access the 'ansible_host_or_ip' private IP of ansible node. Additionally, specify whether IBM provided or customer provided linux subscription should be used. For IBM provided subscription leave custom_os_registration empty. For customer provided subscription set a username and a password inside custom_os_registration. Customer provided linux subscription requires the use of either an IBM provided image ending in BYOL or a custom image. The ansible host must have access to the power virtual server instance and ansible host OS must be RHEL distribution."
  sensitive   = true
  type = object(
    {
      enable             = bool
      bastion_host_ip    = string
      ansible_host_or_ip = string
      ssh_private_key    = string
      custom_os_registration = optional(object({
        username = string
        password = string
      }))
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
    condition     = var.pi_instance_init_linux != null ? var.pi_instance_init_linux.enable ? var.pi_instance_init_linux.bastion_host_ip != "" && var.pi_instance_init_linux.bastion_host_ip != null && var.pi_instance_init_linux.ansible_host_or_ip != "" && var.pi_instance_init_linux.ansible_host_or_ip != null && var.pi_instance_init_linux.ssh_private_key != "" && var.pi_instance_init_linux.ssh_private_key != null ? true : false : true : true
    error_message = "If 'enable' is true, then all attributes of 'pi_instance_init_linux' must be provided."
  }
}

variable "ansible_vault_password" {
  description = "Vault password to encrypt OS registration parameters. Only required with customer provided linux subscription (specified in pi_instance_init_linux.custom_os_registration). Password requirements: 15-100 characters and at least one uppercase letter, one lowercase letter, one number, and one special character. Allowed characters: A-Z, a-z, 0-9, !#$%&()*+-.:;<=>?@[]_{|}~."
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition     = var.pi_instance_init_linux.custom_os_registration == null ? true : var.ansible_vault_password != null
    error_message = "Specifying custom_os_registration requires an ansible_vault_password so your credentials are stored securely."
  }
}

variable "pi_network_services_config" {
  description = "Configures network services proxy, NTP, NFS and DNS on PowerVS instance. Requires 'pi_instance_init_linux' to be specified to configure these services. The 'opts' attribute can take in comma separated values."
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

  validation {
    condition     = var.pi_network_services_config == null ? true : !var.pi_network_services_config.squid.enable || can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}:\\d+$", var.pi_network_services_config.squid.squid_server_ip_port))
    error_message = "squid_server_ip_port must be in the format: x.x.x.x:y, where x=ip and y=port"
  }

  validation {
    condition     = var.pi_network_services_config == null ? true : !var.pi_network_services_config.nfs.enable || (var.pi_network_services_config.nfs.nfs_server_path != "" && var.pi_network_services_config.nfs.nfs_client_path != "" && var.pi_network_services_config.nfs.opts != "" && var.pi_network_services_config.nfs.fstype != "")
    error_message = "Enabling NFS requires that nfs_server_path, nfs_client_path, opts, and fstype are specified."
  }

  validation {
    condition     = var.pi_network_services_config == null ? true : !var.pi_network_services_config.dns.enable || can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", var.pi_network_services_config.dns.dns_server_ip))
    error_message = "Enabling DNS requires dns_server_ip to be a valid IPv4 address."
  }

  validation {
    condition     = var.pi_network_services_config == null ? true : !var.pi_network_services_config.ntp.enable || can(regex("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}$", var.pi_network_services_config.ntp.ntp_server_ip))
    error_message = "Enabling NTP requires ntp_server_ip to be a valid IPv4 address."
  }
}
