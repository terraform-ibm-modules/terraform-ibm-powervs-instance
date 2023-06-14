ibmcloud_api_key       = "<api_key>"
powervs_zone           = "<powervs_zone>"
powervs_workspace_name = "<existing_workspace_name>"
resource_group_name    = "<existing_rg_name>"
powervs_sshkey_name    = "<ssh_key_name>"
powervs_networks       = ["mgmt_net", "bkp_net"]
powervs_instance_init = {
  enable            = "<true or false>"
  access_host_or_ip = "<public ip>"
  ssh_private_key   = <<-EOF
<private-key-file-value>
EOF
}

## Optional. Requires powervs_instance_init to be enabled
powervs_proxy_settings = {
  proxy_host_or_ip_port = "<ip:port>" #10.30.10.4:3128
  no_proxy_hosts        = "161.0.0.0/8,10.0.0.0/8"
}

## Optional. Requires powervs_instance_init to be enabled
powervs_configure_network_services = {
  nfs = { enable = "<true or false>", nfs_server_path = "10.20.10.4:/nfs", nfs_client_path = "/nfs" }
  dns = { enable = "<true or false>", dns_server_ip = "" }
  ntp = { enable = "<true or false>", ntp_server_ip = "" }
}
