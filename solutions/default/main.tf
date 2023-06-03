locals {
  ibm_powervs_zone_region_map = {
    "lon04"    = "lon"
    "lon06"    = "lon"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "tor01"    = "tor"
    "mon01"    = "mon"
    "dal12"    = "us-south"
    "dal13"    = "us-south"
    "osa21"    = "osa"
    "tok04"    = "tok"
    "syd04"    = "syd"
    "syd05"    = "syd"
    "us-east"  = "us-east"
    "us-south" = "us-south"
    "sao01"    = "sao"
    "sao04"    = "sao"
    "wdc04"    = "us-east"
    "wdc06"    = "us-east"
    "wdc07"    = "us-east"
  }

  ibm_powervs_zone_cloud_region_map = {
    "syd04"    = "au-syd"
    "syd05"    = "au-syd"
    "eu-de-1"  = "eu-de"
    "eu-de-2"  = "eu-de"
    "lon04"    = "eu-gb"
    "lon06"    = "eu-gb"
    "tok04"    = "jp-tok"
    "us-east"  = "us-east"
    "us-south" = "us-south"
    "dal12"    = "us-south"
    "dal13"    = "us-south"
    "tor01"    = "ca-tor"
    "osa21"    = "jp-osa"
    "sao01"    = "br-sao"
    "sao04"    = "br-sao"
    "mon01"    = "ca-tor"
    "wdc04"    = "us-east"
    "wdc06"    = "us-east"
    "wdc07"    = "us-east"
  }
}

# There are discrepancies between the region inputs on the powervs terraform resource, and the vpc ("is") resources
provider "ibm" {
  region           = lookup(local.ibm_powervs_zone_region_map, var.powervs_zone, null)
  zone             = var.powervs_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

provider "ibm" {
  alias            = "ibm-is"
  region           = lookup(local.ibm_powervs_zone_cloud_region_map, var.powervs_zone, null)
  zone             = var.powervs_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}

#####################################################
# Create a new PowerVS infrastructure from scratch
#####################################################

locals {
  powervs_workspace_name = "${var.prefix}-${var.powervs_zone}-${var.powervs_workspace_name}"
  powervs_sshkey_name    = "${var.prefix}-${var.powervs_zone}-${var.powervs_sshkey_name}"
  powervs_instance_name  = var.powervs_instance_name
}

# Security Notice
# The private key generated by this resource will be stored unencrypted in your Terraform state file.
# Use of this resource for production deployments is not recommended.
# Instead, generate a private key file outside of Terraform and distribute it securely to the system where
# Terraform will be run.

resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "ibm_is_ssh_key" "ssh_key" {
  provider   = ibm.ibm-is
  name       = local.powervs_sshkey_name
  public_key = trimspace(tls_private_key.tls_key.public_key_openssh)
}

module "resource_group" {
  source = "git::https://github.com/terraform-ibm-modules/terraform-ibm-resource-group.git?ref=v1.0.5"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.resource_group == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.resource_group
}

module "powervs_infrastructure" {

  # Add explicit depends_on here due to https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/issues/143
  depends_on                  = [module.resource_group]
  source                      = "git::https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure.git?ref=v8.1.3"
  powervs_zone                = var.powervs_zone
  powervs_resource_group_name = module.resource_group.resource_group_name
  powervs_workspace_name      = local.powervs_workspace_name
  powervs_sshkey_name         = local.powervs_sshkey_name
  ssh_public_key              = ibm_is_ssh_key.ssh_key.public_key
  ssh_private_key             = trimspace(tls_private_key.tls_key.private_key_openssh)
  powervs_management_network  = var.powervs_management_network
  powervs_backup_network      = var.powervs_backup_network
  transit_gateway_name        = var.transit_gateway_name
  reuse_cloud_connections     = true
  cloud_connection_count      = var.cloud_connection["count"]
  cloud_connection_speed      = var.cloud_connection["speed"]
  cloud_connection_gr         = var.cloud_connection["global_routing"]
  cloud_connection_metered    = var.cloud_connection["metered"]

}

locals {
  additional_networks = [var.powervs_management_network["name"], var.powervs_backup_network["name"]]
}

#####################################################
# Deploy PowerVS Instance
#####################################################

module "powervs_instance" {
  depends_on = [module.powervs_infrastructure]
  source     = "../../"

  pi_zone                = var.powervs_zone
  pi_resource_group_name = module.resource_group.resource_group_name
  pi_workspace_name      = local.powervs_workspace_name
  pi_sshkey_name         = local.powervs_sshkey_name
  pi_instance_name       = local.powervs_instance_name
  pi_os_image_name       = var.powervs_os_image_name
  pi_networks            = local.additional_networks
  pi_sap_profile_id      = var.powervs_sap_profile_id
  pi_storage_config      = var.powervs_storage_config
}
