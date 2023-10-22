locals {
  powervs_resource_group_name = module.resource_group.resource_group_name
  powervs_workspace_name      = "${var.prefix}-${var.powervs_zone}-${var.powervs_workspace_name}"
  powervs_ssh_public_key      = { name = "${var.prefix}-${var.powervs_zone}-pi-ssh-key", value = var.powervs_ssh_public_key }
}

###########################################
# Locals for PowerVS instance
###########################################
locals {

  pi_workspace_guid     = module.powervs_infrastructure.pi_workspace_guid
  pi_networks           = [module.powervs_infrastructure.pi_private_subnet_1, module.powervs_infrastructure.pi_private_subnet_2]
  pi_image_id           = lookup(module.powervs_infrastructure.pi_images, var.powervs_os_image_name, null)
  powervs_instance_name = "${var.prefix}-${var.powervs_instance_name}"

}
