[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-iam-user Example

## Basic usage

The code in [main.tf] defines an example for creating three users and attaching two IAM policies as well as a custom inline policy.
The custom inline policy is adapted based on this [AWS documentation example] for creating a policy which allows only MFA-authenticated IAM users to manage their own credentials.
The `AllowManageOwnGitCredentials`, `AllowManageOwnSSHPublicKeys` and `AllowManageOwnSigningCertificates` statements have been left out for brevity.

```hcl
module "iam-users" {
  source  = "mineiros-io/iam-user/aws"
  version = "~> 0.2.0"

  names = [
    "user.one",
    "user.two",
    "user.three",
  ]

  policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/job-function/Billing",
  ]

  policy_statements = [
    {
      sid    = "AllowViewAccountInfo",
      effect = "Allow",
      actions = [
          "iam:GetAccountPasswordPolicy",
          "iam:GetAccountSummary",
          "iam:ListVirtualMFADevices"
        ],
      resources = ["*"]
    },
    {
      sid    = "AllowManageOwnPasswords",
      effect = "Allow",
      actions = [
            "iam:ChangePassword",
            "iam:GetUser"
        ],
      resources = ["arn:aws:iam::*:user/&{aws:username}"]
    },
    {
      sid    = "AllowManageOwnAccessKeys",
      effect = "Allow",
      actions = [
            "iam:CreateAccessKey",
            "iam:DeleteAccessKey",
            "iam:ListAccessKeys",
            "iam:UpdateAccessKey"
        ],
      resources = ["arn:aws:iam::*:user/&{aws:username}"]
    },
    {
      sid    = "AllowManageOwnVirtualMFADevice",
      effect = "Allow",
      actions = [
            "iam:CreateVirtualMFADevice",
            "iam:DeleteVirtualMFADevice"
        ],
      resources = ["arn:aws:iam::*:mfa/&{aws:username}"]
    },
    {
      sid    = "AllowManageOwnUserMFA",
      effect = "Allow",
      actions = [
            "iam:DeactivateMFADevice",
            "iam:EnableMFADevice",
            "iam:ListMFADevices",
            "iam:ResyncMFADevice"
        ],
      resources = ["arn:aws:iam::*:user/&{aws:username}"]
    },
    {
      sid    = "DenyAllExceptListedIfNoMFA"
      effect = "Deny"
      not_actions = [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:ResyncMFADevice",
        "sts:GetSessionToken",
      ]
      resources = ["*"]
      conditions = [
        {
          test     = "ConditionIfBoolExists"
          variable = "aws:MultiFactorAuthPresent"
          values   = ["false"]
        }
      ]
    }
  ]
}
```

## Running the example

### Cloning the repository

```bash
git clone https://github.com/mineiros-io/terraform-aws-iam-user.git
cd terraform-aws-iam-user/terraform/examples/require-mfa-credentials
```

### Initializing Terraform

Run `terraform init` to initialize the example. The output should look like:

### Planning the example

Run `terraform plan` to preview the creation of the resources. Attention: We are not creating a plan output file in this case. In a production environment, it would be recommended to create a plan file first that can be applied in an isolated apply run.


### Applying the example

Run `terraform apply -auto-approve` to create the resources. Attention: this will not ask for confirmation and also not use the previously run plan as no plan output file was used.

### Destroying the example

Run `terraform destroy -refresh=false -auto-approve` to destroy all previously created resources again.

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-user

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

[main.tf]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples/require-mfa-credentials/main.tf
[AWS documentation example]: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_examples_aws_my-sec-creds-self-manage.html
