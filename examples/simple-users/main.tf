# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE MULTIPLE IAM USERS AT ONCE
# This example shows how to create multiple users at once by passing a list
# of desired usernames to the module. We also attach some default IAM Policies
# to the created users.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

# ------------------------------------------------------------------------------
# CREATE THE IAM USERS AND ATTACH DEFAULT IAM POLICIES
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
}
