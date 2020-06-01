[<img src="https://raw.githubusercontent.com/mineiros-io/brand/master/mineiros-primary-logo.svg" width="400"/>](https://www.mineiros.io/?ref=terraform-aws-iam-user)

[![Build Status](https://mineiros.semaphoreci.com/badges/terraform-aws-iam-user/branches/master.svg?style=shields&key=04f8b96b-178d-4ff2-b8c6-02228fc80789)](https://mineiros.semaphoreci.com/projects/terraform-aws-iam-user)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-user.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-user/releases)
[![license](https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg)](https://opensource.org/licenses/Apache-2.0)
[![Terraform Version](https://img.shields.io/badge/terraform-~%3E%200.12.20-623CE4.svg)](https://github.com/hashicorp/terraform/releases)
[<img src="https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack">](https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg)

# terraform-aws-iam-user Example

## Basic usage

The code in [main.tf](https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples/iam-user-force-mfa/main.tf) defines an example for creating three users and attaching two IAM policies as well as a custom inline policy which enforces MFA activation to perform any action to each of them.

```hcl
module "iam-users" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-user.git?ref=v0.0.3"

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
      resources = ["arn:aws:iam::*:user/${aws:username}"]
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
      resources = ["arn:aws:iam::*:user/${aws:username}"]
    },
    {
      sid    = "AllowManageOwnSigningCertificates",
      effect = "Allow",
      actions = [
            "iam:DeleteSigningCertificate",
            "iam:ListSigningCertificates",
            "iam:UpdateSigningCertificate",
            "iam:UploadSigningCertificate"
        ],
      resources = ["arn:aws:iam::*:user/${aws:username}"]
    },
    {
      sid    = "AllowManageOwnSSHPublicKeys",
      effect = "Allow",
      actions = [
            "iam:DeleteSSHPublicKey",
            "iam:GetSSHPublicKey",
            "iam:ListSSHPublicKeys",
            "iam:UpdateSSHPublicKey",
            "iam:UploadSSHPublicKey"
        ],
      resources = ["arn:aws:iam::*:user/${aws:username}"]
    },
    {
      sid    = "AllowManageOwnGitCredentials",
      effect = "Allow",
      actions = [
            "iam:CreateServiceSpecificCredential",
            "iam:DeleteServiceSpecificCredential",
            "iam:ListServiceSpecificCredentials",
            "iam:ResetServiceSpecificCredential",
            "iam:UpdateServiceSpecificCredential"
        ],
      resources = ["arn:aws:iam::*:user/${aws:username}"]
    },
    {
      sid    = "AllowManageOwnVirtualMFADevice",
      effect = "Allow",
      actions = [
            "iam:CreateVirtualMFADevice",
            "iam:DeleteVirtualMFADevice"
        ],
      resources = ["arn:aws:iam::*:mfa/${aws:username}"]
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
      resources = ["arn:aws:iam::*:user/${aws:username}"]
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
cd terraform-aws-iam-user/terraform/examples/iam-user-force-mfa
```

### Initializing Terraform

Run `terraform init` to initialize the example. The output should look like:

### Planning the example

Run `terraform plan` to preview the creation of the resources. Attention: We are not creating a plan output file in this case. In a production environment, it would be recommended to create a plan file first that can be applied in an isolated apply run.


### Applying the example

Run `terraform apply -auto-approve` to create the resources. Attention: this will not ask for confirmation and also not use the previously run plan as no plan output file was used.

### Destroying the example

Run `terraform destroy -refresh=false -auto-approve` to destroy all previously created resources again.
