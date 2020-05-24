# ------------------------------------------------------------------------------
# Example Setup
# ------------------------------------------------------------------------------

provider "aws" {
  version = "~> 2.0"
}

# ------------------------------------------------------------------------------
# Example Usage
# ------------------------------------------------------------------------------

module "iam-user" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-user.git?ref=v0.0.2"

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
