#####################################################
# Create Power Virtual server Instance
#####################################################

resource "ibm_pi_instance" "instance" {
  pi_cloud_instance_id     = var.pi_workspace_guid
  pi_instance_name         = var.pi_instance_name
  pi_image_id              = var.pi_boot_image_id
  pi_sap_profile_id        = var.pi_sap_profile_id == null ? null : var.pi_sap_profile_id
  pi_processors            = var.pi_sap_profile_id != null ? null : var.pi_number_of_processors
  pi_memory                = var.pi_sap_profile_id != null ? null : var.pi_memory_size
  pi_sys_type              = var.pi_sap_profile_id != null ? null : var.pi_server_type
  pi_proc_type             = var.pi_sap_profile_id != null ? null : var.pi_cpu_proc_type
  pi_key_pair_name         = var.pi_ssh_public_key_name
  pi_health_status         = "OK"
  pi_storage_pool_affinity = false

  pi_placement_group_id          = var.pi_replicants == null ? var.pi_placement_group_id : null
  pi_replicants                  = var.pi_replicants != null ? var.pi_replicants.count : null
  pi_replication_policy          = var.pi_replicants != null ? var.pi_replicants.policy : null
  pi_storage_pool                = var.pi_boot_image_storage_pool
  pi_storage_type                = var.pi_boot_image_storage_tier
  pi_affinity_policy             = var.pi_affinity_policy
  pi_affinity_instance           = var.pi_affinity_policy == "affinity" && var.pi_affinity != null ? var.pi_affinity.affinity_instance : null
  pi_affinity_volume             = var.pi_affinity_policy == "affinity" && var.pi_affinity != null ? var.pi_affinity.affinity_volume : null
  pi_anti_affinity_instances     = var.pi_affinity_policy == "anti-affinity" && var.pi_anti_affinity != null ? var.pi_anti_affinity.anti_affinity_instances : null
  pi_anti_affinity_volumes       = var.pi_affinity_policy == "anti-affinity" && var.pi_anti_affinity != null ? var.pi_anti_affinity.anti_affinity_volumes : null
  pi_license_repository_capacity = var.pi_license_repository_capacity
  pi_volume_ids                  = var.pi_existing_volume_ids != null ? var.pi_existing_volume_ids : null
  pi_user_tags                   = var.pi_user_tags != null ? var.pi_user_tags : []
  pi_user_data                   = var.pi_user_data
  pi_pin_policy                  = var.pi_pin_policy

  dynamic "pi_network" {
    for_each = var.pi_networks
    content {
      network_id = pi_network.value.id
      ip_address = pi_network.value.ip != null && pi_network.value.ip != "" ? pi_network.value.ip : null
    }
  }

  timeouts {
    create = "50m"
  }

  lifecycle {
    ignore_changes = [pi_cloud_instance_id, pi_image_id, pi_user_data]
  }
}

#####################################################
# For outputs
#####################################################

data "ibm_pi_instance_ip" "instance_primary_ip_ds" {
  depends_on           = [ibm_pi_instance.instance]
  pi_network_name      = var.pi_networks[0].name
  pi_instance_name     = ibm_pi_instance.instance.pi_instance_name
  pi_cloud_instance_id = var.pi_workspace_guid
}

data "ibm_pi_instance" "instance_ips_ds" {
  depends_on           = [ibm_pi_instance.instance]
  pi_instance_name     = ibm_pi_instance.instance.pi_instance_name
  pi_cloud_instance_id = var.pi_workspace_guid
}
