locals {
  pi_linux_proxy_settings = var.pi_instance_init_linux != null ? {
    enable                = var.pi_instance_init_linux.proxy_host_or_ip_port != null ? var.pi_instance_init_linux.proxy_host_or_ip_port != "" ? true : false : false
    proxy_host_or_ip_port = var.pi_instance_init_linux.proxy_host_or_ip_port
    no_proxy_hosts        = var.pi_instance_init_linux.no_proxy_hosts
  } : null
}
