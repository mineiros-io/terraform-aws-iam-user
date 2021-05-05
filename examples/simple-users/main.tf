# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# CREATE MULTIPLE IAM USERS AT ONCE
# This example shows how to create multiple users at once by passing a list
# of desired usernames to the module. We also attach some default IAM Policies
# to the created users.
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
  region = "eu-west-1"
}

# ------------------------------------------------------------------------------
# CREATE THE IAM USERS AND ATTACH DEFAULT IAM POLICIES
# ------------------------------------------------------------------------------

module "iam-users" {
  source  = "mineiros-io/iam-user/aws"
  version = "~> 0.3.1"

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
