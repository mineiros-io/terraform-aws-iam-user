package test

import (
	"fmt"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// TestCreateBasicIamUsers
// tests the creation of a list of IAM Users with some attached default IAM Policies
func TestCreateBasicIamUsers(t *testing.T) {
	t.Parallel()

	randomAwsRegion := aws.GetRandomRegion(t, nil, nil)

	expectedUserNames := []string{
		fmt.Sprintf("first.testuser-%s", random.UniqueId()),
		fmt.Sprintf("second.testuser-%s", random.UniqueId()),
	}

	exptectedIamPolicyARNs := []string{
		"arn:aws:iam::aws:policy/ReadOnlyAccess",
		"arn:aws:iam::aws:policy/job-function/Billing",
	}

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "./create-basic-iam-users",
		Vars: map[string]interface{}{
			"aws_region":  randomAwsRegion,
			"names":       expectedUserNames,
			"policy_arns": exptectedIamPolicyARNs,
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	outputs := terraform.OutputAll(t, terraformOptions)
	createdUsers, _ := outputs["all"].(map[string]interface{})["users"].(map[string]interface{})

	// Validate that the qty of creates users matches the desired qty
	assert.Equal(t, len(expectedUserNames), len(createdUsers), "Expected %d users to be created. Got %d instead.", len(expectedUserNames), len(createdUsers))

	// Validate that the users with the expected usernames exist
	for _, name := range expectedUserNames {
		assert.Contains(t, createdUsers, name, "Expected username %s not found.", name)
	}

	// Validate that quantity of user_policy_attachment's located in the outputs
	userPolicyAttachments := outputs["all"].(map[string]interface{})["user_policy_attachment"].([]interface{})

	// If we attach two policies to two users, we should be able to locate four attachments in the outputs
	assert.Equal(t, (len(exptectedIamPolicyARNs) * len(expectedUserNames)), len(userPolicyAttachments), "Exptected %s user policy attachment. Found %d instead", len(expectedUserNames), len(userPolicyAttachments))
}
