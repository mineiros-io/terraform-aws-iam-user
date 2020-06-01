# ------------------------------------------------------------------------------
# Example Setup
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

# ------------------------------------------------------------------------------
# Example Usage
# ------------------------------------------------------------------------------

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
      sid    = "AllowViewAccountInfo"
      effect = "Allow"

      actions = [
        "iam:GetAccountPasswordPolicy",
        "iam:GetAccountSummary",
        "iam:ListVirtualMFADevices"
      ]

      resources = ["*"]
    },
    {
      sid    = "AllowManageOwnPasswords"
      effect = "Allow"

      actions = [
        "iam:ChangePassword",
        "iam:GetUser"
      ]

      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]

    },
    {
      sid    = "AllowManageOwnAccessKeys"
      effect = "Allow"
      actions = [
        "iam:CreateAccessKey",
        "iam:DeleteAccessKey",
        "iam:ListAccessKeys",
        "iam:UpdateAccessKey"
      ],
      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]
    },
    {
      sid    = "AllowManageOwnSigningCertificates"
      effect = "Allow"
      actions = [
        "iam:DeleteSigningCertificate",
        "iam:ListSigningCertificates",
        "iam:UpdateSigningCertificate",
        "iam:UploadSigningCertificate"
      ]
      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]
    },
    {
      sid    = "AllowManageOwnSSHPublicKeys"
      effect = "Allow"
      actions = [
        "iam:DeleteSSHPublicKey",
        "iam:GetSSHPublicKey",
        "iam:ListSSHPublicKeys",
        "iam:UpdateSSHPublicKey",
        "iam:UploadSSHPublicKey"
      ]
      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]
    },
    {
      sid    = "AllowManageOwnGitCredentials"
      effect = "Allow"
      actions = [
        "iam:CreateServiceSpecificCredential",
        "iam:DeleteServiceSpecificCredential",
        "iam:ListServiceSpecificCredentials",
        "iam:ResetServiceSpecificCredential",
        "iam:UpdateServiceSpecificCredential"
      ]
      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]
    },
    {
      sid    = "AllowManageOwnVirtualMFADevice"
      effect = "Allow"
      actions = [
        "iam:CreateVirtualMFADevice",
        "iam:DeleteVirtualMFADevice"
      ]
      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]
    },
    {
      sid    = "AllowManageOwnUserMFA"
      effect = "Allow"
      actions = [
        "iam:DeactivateMFADevice",
        "iam:EnableMFADevice",
        "iam:ListMFADevices",
        "iam:ResyncMFADevice"
      ]
      resources = [
        "arn:aws:iam::*:user/&{aws:username}"
      ]
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

      resources = ["*"],

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
