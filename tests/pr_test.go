// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/cloudinfo"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

// Use existing resource group
const resourceGroup = "geretain-test-resources"
const completeExampleDir = "examples/basic"

var sharedInfoSvc *cloudinfo.CloudInfoService

func TestMain(m *testing.M) {
	sharedInfoSvc, _ = cloudinfo.NewCloudInfoServiceFromEnv("TF_VAR_ibmcloud_api_key", cloudinfo.CloudInfoServiceOptions{})
	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string, powervs_zone string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefaultWithVars(&testhelper.TestOptions{
		Testing:       t,
		TerraformDir:  dir,
		Prefix:        prefix,
		ResourceGroup: resourceGroup,
		Region:        powervs_zone,
		ImplicitDestroy: []string{
			"module.powervs_workspace.ibm_resource_instance.pi_workspace",
		},
	})

	options.TerraformVars = map[string]interface{}{
		"prefix":                      options.Prefix,
		"powervs_resource_group_name": options.ResourceGroup,
		"powervs_zone":                options.Region,
		"powervs_ssh_public_key":      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCd6kECDFRccE3AY/3u4FcHoNtNJjE7fCg0INvxAU9i3V8bibnUnDrWYuWV1pUq6wm0+Ab1ECX6R+MUfNC22xhbYQDvdREEfUFIeGPW27kJ3zT4Jxiw0ih23p8Scukk0B7wWaDl+HQnHkZNhD+1I8Y5yGULBqNVnVdFhXQZK03tLBC4OvhQNVbjO93iAkJQYpTGQZGxIlyavEk4T3criztFeMzVieN2J6vbvxDOuqjCGE+VcBaIXHoHIpUu44ZlCax4ArxOx+MlZBb5LXasjdhajKBqSiL7Sknq51ftnAbj0+spqRYpbNrMC2TThYrXLsYQ4EV7nndRpeLqLk+dJoX0F5KuRSOeImvyGPkCpEySzSw2SPjzlMLmJNSFErMZS159F1N6fyjRzEJQYKRu4lRSoVeirNcmM8mfuF3SesRCqy5FuUKr3B/NzJ6hJ+ia8vgy2e6itcynk+QvgLrY/iO8LXy1m9vG/xF8qDvviPsFe4KAe31IyHoIcgncwe3smtU= root@eu-jump-box-1",
	}
	return options
}

func TestRunBranchExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "pib", completeExampleDir, "mad04")

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunMainExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "pim", completeExampleDir, "sao04")

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
