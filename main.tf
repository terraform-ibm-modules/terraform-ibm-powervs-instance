locals {
  ibm_pi_zone_region_map = {
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

  ibm_pi_zone_cloud_region_map = {
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
  region           = lookup(local.ibm_pi_zone_region_map, var.pi_zone, null)
  zone             = var.pi_zone
  ibmcloud_api_key = var.ibmcloud_api_key != null ? var.ibmcloud_api_key : null
}
#####################################################
# PowerVs Instance Create Configuration
#####################################################

locals {
  pi_workspace_type = "power-iaas"
}

data "ibm_resource_group" "resource_group_ds" {
  name = var.pi_resource_group_name
}

data "ibm_resource_instance" "pi_workspace_ds" {
  name              = var.pi_workspace_name
  service           = local.pi_workspace_type
  location          = var.pi_zone
  resource_group_id = data.ibm_resource_group.resource_group_ds.id
}

data "ibm_pi_key" "key_ds" {
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
  pi_key_name          = var.pi_sshkey_name
}

data "ibm_pi_image" "image_ds" {
  pi_image_name        = var.pi_os_image_name
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
}

data "ibm_pi_network" "pi_subnets_ds" {
  count                = length(var.pi_networks)
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
  pi_network_name      = var.pi_networks[count.index]
}

#####################################################
# Create PowerVs Instance
#####################################################

resource "ibm_pi_instance" "instance" {
  pi_cloud_instance_id     = data.ibm_resource_instance.pi_workspace_ds.guid
  pi_instance_name         = var.pi_instance_name
  pi_image_id              = data.ibm_pi_image.image_ds.id
  pi_sap_profile_id        = var.pi_sap_profile_id == null ? null : var.pi_sap_profile_id
  pi_processors            = var.pi_sap_profile_id != null ? null : var.pi_number_of_processors
  pi_memory                = var.pi_sap_profile_id != null ? null : var.pi_memory_size
  pi_sys_type              = var.pi_sap_profile_id != null ? null : var.pi_server_type
  pi_proc_type             = var.pi_sap_profile_id != null ? null : var.pi_cpu_proc_type
  pi_key_pair_name         = data.ibm_pi_key.key_ds.id
  pi_health_status         = "OK"
  pi_storage_pool_affinity = false
  pi_storage_type          = var.pi_boot_image_storage_tier

  dynamic "pi_network" {
    for_each = tolist(data.ibm_pi_network.pi_subnets_ds[*].id)
    content {
      network_id = pi_network.value
    }
  }

  timeouts {
    create = "45m"
  }

}

#####################################################
# Create Disks mapping variables
#####################################################

locals {
  disks_counts   = length(var.pi_storage_config["counts"]) > 0 ? [for x in(split(",", var.pi_storage_config["counts"])) : tonumber(trimspace(x))] : null
  disks_size_tmp = length(var.pi_storage_config["counts"]) > 0 ? [for disk_size in split(",", var.pi_storage_config["disks_size"]) : tonumber(trimspace(disk_size))] : null
  disks_size     = length(var.pi_storage_config["counts"]) > 0 ? flatten([for idx, disk_count in local.disks_counts : [for i in range(disk_count) : local.disks_size_tmp[idx]]]) : null

  tier_types_tmp = length(var.pi_storage_config["counts"]) > 0 ? [for tier_type in split(",", var.pi_storage_config["tiers"]) : trimspace(tier_type)] : null
  tiers_type     = length(var.pi_storage_config["counts"]) > 0 ? flatten([for idx, disk_count in local.disks_counts : [for i in range(disk_count) : local.tier_types_tmp[idx]]]) : null

  disks_name_tmp = length(var.pi_storage_config["counts"]) > 0 ? [for disk_name in split(",", var.pi_storage_config["names"]) : trimspace(disk_name)] : null
  disks_name     = length(var.pi_storage_config["counts"]) > 0 ? flatten([for idx, disk_count in local.disks_counts : [for i in range(disk_count) : local.disks_name_tmp[idx]]]) : null

  disks_number = length(var.pi_storage_config["counts"]) > 0 ? sum([for x in(split(",", var.pi_storage_config["counts"])) : tonumber(trimspace(x))]) : 0
}

#####################################################
# Create Volumes
#####################################################

resource "ibm_pi_volume" "create_volume" {
  depends_on           = [ibm_pi_instance.instance]
  count                = local.disks_number
  pi_volume_size       = local.disks_size[count.index - (local.disks_number * floor(count.index / local.disks_number))]
  pi_volume_name       = "${var.pi_instance_name}-${local.disks_name[count.index - (local.disks_number * floor(count.index / local.disks_number))]}-volume${count.index + 1}"
  pi_volume_type       = local.tiers_type[count.index - (local.disks_number * floor(count.index / local.disks_number))]
  pi_volume_shareable  = false
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid

  timeouts {
    create = "15m"
  }
}

#####################################################
# Attach Volumes to the Instance
#####################################################

resource "ibm_pi_volume_attach" "instance_volumes_attach" {
  depends_on           = [ibm_pi_volume.create_volume, ibm_pi_instance.instance]
  count                = local.disks_number
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
  pi_volume_id         = ibm_pi_volume.create_volume[count.index].volume_id
  pi_instance_id       = ibm_pi_instance.instance.instance_id

  timeouts {
    create = "50m"
    delete = "50m"
  }
}

data "ibm_pi_instance_ip" "instance_mgmt_ip_ds" {
  depends_on           = [ibm_pi_instance.instance]
  pi_network_name      = var.pi_networks[0]
  pi_instance_name     = ibm_pi_instance.instance.pi_instance_name
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
}

data "ibm_pi_instance" "instance_ips_ds" {
  depends_on           = [ibm_pi_instance.instance]
  pi_instance_name     = ibm_pi_instance.instance.pi_instance_name
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
}
