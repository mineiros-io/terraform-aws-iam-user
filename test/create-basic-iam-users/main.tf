# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TEST MODULE THAT IS USED BY THE UNIT TESTS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

module "iam-users" {
  source = "../.."

  names       = var.names
  policy_arns = var.policy_arns
}
