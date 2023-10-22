locals {
  pi_boot_image_storage_tier = var.pi_sap_profile_id == null ? "tier3" : "tier1"
}

#####################################################
# Create Power Virtual server Instance
#####################################################

resource "ibm_pi_instance" "instance" {
  pi_cloud_instance_id     = var.pi_workspace_guid
  pi_instance_name         = var.pi_instance_name
  pi_image_id              = var.pi_image_id
  pi_sap_profile_id        = var.pi_sap_profile_id == null ? null : var.pi_sap_profile_id
  pi_processors            = var.pi_sap_profile_id != null ? null : var.pi_number_of_processors
  pi_memory                = var.pi_sap_profile_id != null ? null : var.pi_memory_size
  pi_sys_type              = var.pi_sap_profile_id != null ? null : var.pi_server_type
  pi_proc_type             = var.pi_sap_profile_id != null ? null : var.pi_cpu_proc_type
  pi_key_pair_name         = var.pi_ssh_public_key_name
  pi_health_status         = "OK"
  pi_storage_pool_affinity = false
  pi_storage_type          = local.pi_boot_image_storage_tier

  dynamic "pi_network" {
    for_each = var.pi_networks
    content {
      network_id = pi_network.value.id
    }
  }

  timeouts {
    create = "50m"
  }

  lifecycle {
    ignore_changes = [pi_cloud_instance_id, pi_image_id]
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
