########################################
#  Create / Reuse Resource group
########################################

module "resource_group" {
  source  = "terraform-ibm-modules/resource-group/ibm"
  version = "1.1.4"
  # if an existing resource group is not set (null) create a new one using prefix
  resource_group_name          = var.powervs_resource_group_name == null ? "${var.prefix}-resource-group" : null
  existing_resource_group_name = var.powervs_resource_group_name
}

####################################################
# Create a new PowerVS Workspace
#####################################################

module "powervs_infrastructure" {
  depends_on = [module.resource_group]
  source     = "terraform-ibm-modules/powervs-workspace/ibm"
  version    = "1.2.1"

  pi_zone                = var.powervs_zone
  pi_resource_group_name = local.powervs_resource_group_name
  pi_workspace_name      = local.powervs_workspace_name
  pi_image_names         = var.powervs_image_names
  pi_ssh_public_key      = local.powervs_ssh_public_key
  pi_private_subnet_1    = var.powervs_private_subnet_1
  pi_private_subnet_2    = var.powervs_private_subnet_2
  pi_cloud_connection    = var.powervs_cloud_connection
}
