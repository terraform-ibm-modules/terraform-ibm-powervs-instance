#####################################################
# PowerVs Instance Create Configuration
#####################################################

locals {
  pi_workspace_type          = "power-iaas"
  pi_boot_image_storage_tier = var.pi_sap_profile_id == null ? "tier3" : "tier1"
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
  pi_storage_type          = local.pi_boot_image_storage_tier

  dynamic "pi_network" {
    for_each = tolist(data.ibm_pi_network.pi_subnets_ds[*].id)
    content {
      network_id = pi_network.value
    }
  }

  timeouts {
    create = "50m"
  }

}

#####################################################
# Create Volumes
#####################################################

locals {
  volume_list = flatten([
    for vol in var.pi_storage_config : [
      for i in range(1, vol.count + 1) : {
        name  = "${vol.name}-${i}"
        size  = vol.size
        tier  = vol.tier
        mount = vol.mount
      }
    ]
  ])
}

resource "ibm_pi_volume" "create_volume" {
  depends_on = [ibm_pi_instance.instance]
  count      = length(local.volume_list)

  pi_volume_name       = local.volume_list[count.index].name
  pi_volume_size       = local.volume_list[count.index].size
  pi_volume_type       = local.volume_list[count.index].tier
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
  count                = length(local.volume_list)
  pi_cloud_instance_id = data.ibm_resource_instance.pi_workspace_ds.guid
  pi_volume_id         = ibm_pi_volume.create_volume[count.index].volume_id
  pi_instance_id       = ibm_pi_instance.instance.instance_id

  timeouts {
    create = "50m"
    delete = "50m"
  }
}

#####################################################
# For Outputs
#####################################################

locals {

  fs_pattern = join("|", [for vol in var.pi_storage_config : vol.name])
  instance_wwn_by_fs = { for vol in ibm_pi_volume.create_volume :
    regex(local.fs_pattern, vol.pi_volume_name) => vol.wwn...
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
