#####################################################
# PowerVS Instance Module
#####################################################

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    # tflint-ignore: terraform_unused_required_providers
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = ">= 1.71.3"
    }
  }
}
