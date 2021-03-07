# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY USERS THAT REQUIRE MFA TO BE ACTIVATED
# This example creates a set of three users with two attached default
# IAM Policies. It will also create and attach custom IAM Policies
# that allow the users to self-manage their credentials if MFA is active.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
  region = "eu-west-1"
}

# ------------------------------------------------------------------------------
# Create the IAM Users with attached IAM Policies
# ------------------------------------------------------------------------------

module "iam-users" {
  source  = "mineiros-io/iam-user/aws"
  version = "~> 0.3.0"

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
