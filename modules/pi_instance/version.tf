#####################################################
# PowerVS Instance Module
#####################################################

terraform {
  required_version = ">= 1.3, < 1.6"
  required_providers {
    # Use "greater than or equal to" range in modules
    # tflint-ignore: terraform_unused_required_providers
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">=1.52.0"
    }
  }
}
