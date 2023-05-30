# Basic Power Virtual Server Module Example

This example illustrates how to use the `powervs-instance` module.
It provisions the following infrastructure:
- Creates a [PowerVS infrastructure ](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure) calling basic example of this module <br/>
- Creates an IBM® Power Virtual Server Instance.
- Creates Volumes and Attaches it to the instance.

:warning: For experimentation purposes only.
For ease of use, this quick start example generates a private/public ssh key pair. The private key generated in this example will be stored unencrypted in your Terraform state file.
Use of this resource for production deployments is not recommended. Instead, generate a ssh key pair outside of Terraform and pass the public key via the [ssh_public_key input](https://github.com/terraform-ibm-modules/terraform-ibm-powervs-infrastructure/tree/v0.1#input_ssh_public_key)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
