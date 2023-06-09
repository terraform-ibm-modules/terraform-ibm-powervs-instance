variable "access_host_or_ip" {
  description = "Public IP of Bastion Host"
  type        = string
}

variable "target_server_ip" {
  description = "Private IP of PowerVS instance reachable from the access host."
  type        = string
}

variable "ssh_private_key" {
  description = "Private Key to configure Instance, Will not be uploaded to server."
  type        = string
  sensitive   = true
}

variable "pi_proxy_settings" {
  description = "Configures a PowerVS instance to have internet access by setting proxy on it. E.g., 10.10.10.4:3128 <ip:port>"
  type = object(
    {
      enable                = string
      proxy_host_or_ip_port = string
      no_proxy_hosts        = string
    }
  )
}

variable "pi_storage_config" {
  description = "File systems to be created and mounted on PowerVS instance. 'size' is in GB. 'count' specify over how many storage volumes the file system will be striped. 'tier' specifies the storage tier in PowerVS workspace, 'mount' specifies the mount point on the OS. 'wwns' specifies the comma separated volume ids "
  type = list(object({
    name  = string
    size  = string
    count = string
    tier  = string
    mount = string
    wwns  = list(string)
  }))
}
