#####################################################
# Validation for PowerVS Instance module
#####################################################

locals {
  affinity_policy_enabled      = var.pi_affinity_policy == "affinity"
  anti_affinity_policy_enabled = var.pi_affinity_policy == "anti-affinity"

  affinity_input_validate_msg   = "When pi_affinity_policy is set to 'affinity', the pi_affinity object should not be null. pi_affinity object value must be set with either 'affinity_instance' or 'affinity_volume' must be provided in , but not both."
  valid_affinity_input_provided = !(local.affinity_policy_enabled) || var.pi_affinity != null
  # tflint-ignore: terraform_unused_declarations
  validate_affinity = regex("^${local.affinity_input_validate_msg}$", (local.valid_affinity_input_provided ? local.affinity_input_validate_msg : ""))

  anti_affinity_input_validate_msg   = "When pi_affinity_policy is set to 'anti-affinity', the pi_anti_affinity object should not be null. pi_anti_affinity object value must be set with either 'anti_affinity_instances' or 'anti_affinity_volumes' must be provided, but not both."
  valid_anti_affinity_input_provided = !(local.anti_affinity_policy_enabled) || var.pi_anti_affinity != null
  # tflint-ignore: terraform_unused_declarations
  validate_anti_affinity = regex("^${local.anti_affinity_input_validate_msg}$", (local.valid_anti_affinity_input_provided ? local.anti_affinity_input_validate_msg : ""))
}
