ibmcloud_api_key                = ""
powervs_zone                    = ""
powervs_workspace_guid          = ""
powervs_ssh_public_key_name     = ""
powervs_networks                = [{ "cidr" : "", "id" : "", "name" : "" }, { "cidr" : "", "id" : "", "name" : "" }]
powervs_image_id                = ""
powervs_boot_image_storage_tier = "tier3" # supported values tier3 and tier1
powerv_cluster_nodes            = 3
powervs_instance_name           = "ha2"
powervs_server_type             = "s922"
powervs_cpu_proc_type           = "shared"
powervs_number_of_processors    = "0.25"
powervs_memory_size             = "2"
powervs_dedicated_filesystem_config = [
  {
    name = "data", size = "400", count = "1", tier = "tier1", mount = "/data"
  }
]
