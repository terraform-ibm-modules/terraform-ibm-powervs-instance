locals {

  pi_proxy_settings = {
    enable                = var.pi_proxy_settings != null ? var.pi_proxy_settings.proxy_host_or_ip_port != "" ? true : false : false
    proxy_host_or_ip_port = var.pi_proxy_settings != null ? var.pi_proxy_settings.proxy_host_or_ip_port != "" ? var.pi_proxy_settings.proxy_host_or_ip_port : "" : ""
    no_proxy_hosts        = var.pi_proxy_settings != null ? var.pi_proxy_settings.no_proxy_hosts != "" ? var.pi_proxy_settings.no_proxy_hosts : "" : ""
  }
}
