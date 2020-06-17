# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# TEST MODULE THAT IS USED BY THE UNIT TESTS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

variable "aws_region" {
  description = "The AWS region to deploy the example in."
  type        = string
  default     = "us-east-1"
}

variable "names" {
  description = "A list of names of IAM Users to create."
  type        = set(string)
  default = [
    "testuser",
    "another.testuser"
  ]
}

variable "policy_arns" {
  description = "A list of IAM Policy ARNs that will be attached to the created IAM Users."
  type        = set(string)
  default = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess",
    "arn:aws:iam::aws:policy/job-function/Billing",
  ]
}
