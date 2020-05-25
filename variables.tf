# ------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables.
# ------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These variables must be set when using this module.
# ------------------------------------------------------------------------------

variable "names" {
  type        = set(string)
  description = "(Required) A set of names. Every name must consist of upper and lowercase alphanumeric characters with no spaces. You can also include any of the following characters: '=,.@-_'. User names are not distinguished by case."
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden.
# ------------------------------------------------------------------------------
variable "path" {
  type        = string
  description = "(Optional) Path in which to create the user. Default is \"/\"."
  default     = "/"
}

variable "permissions_boundary" {
  type        = string
  description = "(Optional) The ARN of the policy that is used to set the permissions boundary for the user."
  default     = null
}

variable "force_destroy" {
  type        = bool
  description = "(Optional) When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed. Default is false."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "(Optional) Key-value map of tags for the IAM user."
  default     = {}
}

variable "policy_statements" {
  type        = list(any)
  description = "(Optional) List of IAM policy statements to attach to the User as an inline policy."
  default     = []
}

variable "policy_arns" {
  type        = set(string)
  description = "(Optional) Set of IAM custom or managed policies ARNs to attach to the User."
  default     = []
}

variable "groups" {
  type        = list(string)
  description = "(Optional) List of IAM groups to add the User to."
  default     = []
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# See https://medium.com/mineiros/the-ultimate-guide-on-how-to-write-terraform-modules-part-1-81f86d31f024
# ------------------------------------------------------------------------------
variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is true."
  default     = true
}

variable "module_depends_on" {
  type        = list(any)
  description = "(Optional) A list of external resources the module depends_on. Default is []."
  default     = []
}
