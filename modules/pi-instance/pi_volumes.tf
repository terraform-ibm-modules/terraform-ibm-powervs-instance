#####################################################
#  Power Virtual server Volumes
#####################################################

locals {

  create_volumes = var.pi_storage_config != null ? var.pi_storage_config[0].count != "" ? true : false : false
  volume_list = local.create_volumes ? flatten([
    for vol in var.pi_storage_config : [
      for i in range(1, vol.count + 1) : {
        name  = "${vol.name}-${i}"
        size  = vol.size
        tier  = vol.tier
        mount = vol.mount
        pool  = can(vol.pool) ? vol.pool : null
      }
    ]
  ]) : []
}

resource "ibm_pi_volume" "create_volume" {
  depends_on = [ibm_pi_instance.instance]
  count      = length(local.volume_list)

  pi_volume_name       = "${var.pi_instance_name}-${local.volume_list[count.index].name}"
  pi_volume_size       = local.volume_list[count.index].size
  pi_volume_type       = local.volume_list[count.index].tier
  pi_volume_pool       = local.volume_list[count.index].pool
  pi_volume_shareable  = false
  pi_cloud_instance_id = var.pi_workspace_guid
  pi_user_tags         = var.pi_user_tags != null ? var.pi_user_tags : []


  timeouts {
    create = "15m"
  }

  lifecycle {
    ignore_changes = [pi_cloud_instance_id]
  }
}

#####################################################
# Attach Volumes to the Instance
#####################################################

resource "ibm_pi_volume_attach" "instance_volumes_attach" {
  depends_on           = [ibm_pi_volume.create_volume, ibm_pi_instance.instance]
  count                = length(local.volume_list)
  pi_cloud_instance_id = var.pi_workspace_guid
  pi_volume_id         = ibm_pi_volume.create_volume[count.index].volume_id
  pi_instance_id       = ibm_pi_instance.instance.instance_id

  timeouts {
    create = "50m"
    delete = "50m"
  }

  lifecycle {
    ignore_changes = [pi_cloud_instance_id, pi_volume_id]
  }
}

#####################################################
# For Outputs
#####################################################

locals {

  fs_pattern = local.create_volumes ? join("|", [for vol in var.pi_storage_config : vol.name]) : ""
  instance_wwn_by_fs = { for vol in ibm_pi_volume.create_volume :
    regex(local.fs_pattern, vol.pi_volume_name) => vol.wwn...
  }
}
