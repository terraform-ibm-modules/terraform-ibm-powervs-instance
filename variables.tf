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

variable "pi_storage_config" {
  description = "File systems to be created and attached to PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS."
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
    }
  ]
}


#####################################################
# PowerVS Instance Initialization
#####################################################

variable "pi_instance_init_linux" {
  description = "Configures a PowerVS linux instance to have internet access by setting proxy on it, updates os and create filesystems using ansible collection [ibm.power_linux_sap collection](https://galaxy.ansible.com/ui/repo/published/ibm/power_linux_sap/). where 'proxy_host_or_ip_port' E.g., 10.10.10.4:3128 <ip:port>, 'bastion_host_ip' is public IP of bastion/jump host to access the private IP of ansible node. this ansible node must have access to the power virtual server  instance."
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
