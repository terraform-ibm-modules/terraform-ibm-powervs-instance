locals {
  ibm_powervs_zone_region_map = {
    "lon04"    = "lon"
    "lon06"    = "lon"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "tor01"    = "tor"
    "mon01"    = "mon"
    "osa21"    = "osa"
    "tok04"    = "tok"
    "syd04"    = "syd"
    "syd05"    = "syd"
    "sao01"    = "sao"
    "us-south" = "us-south"
    "dal10"    = "us-south"
    "dal12"    = "us-south"
    "us-east"  = "us-east"
  }

}

provider "ibm" {
  region           = lookup(local.ibm_powervs_zone_region_map, var.powervs_zone, null)
  zone             = var.powervs_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

#####################################################
# Deploy PowerVS Instance
#####################################################

module "powervs_instance" {
  source = "../../"

  pi_zone                    = var.powervs_zone
  pi_resource_group_name     = var.resource_group_name
  pi_workspace_name          = var.powervs_workspace_name
  pi_sshkey_name             = var.powervs_sshkey_name
  pi_instance_name           = var.powervs_instance_name
  pi_os_image_name           = var.powervs_os_image_name
  pi_networks                = var.powervs_networks
  pi_sap_profile_id          = var.powervs_sap_profile_id
  pi_server_type             = var.powervs_server_type
  pi_number_of_processors    = var.powervs_number_of_processors
  pi_memory_size             = var.powervs_memory_size
  pi_cpu_proc_type           = var.powervs_cpu_proc_type
  pi_storage_config          = var.powervs_storage_config
  pi_instance_init           = var.powervs_instance_init
  pi_proxy_settings          = var.powervs_proxy_settings
  pi_network_services_config = var.powervs_network_services_config
}
