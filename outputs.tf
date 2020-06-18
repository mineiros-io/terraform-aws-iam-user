# ------------------------------------------------------------------------------
# OUTPUT CALCULATED VARIABLES (prefer full objects)
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# OUTPUT ALL RESOURCES AS FULL OBJECTS
# ------------------------------------------------------------------------------

output "users" {
  description = "A list of all created IAM User objects."
  value       = try(aws_iam_user.user, null)
}

output "user_policy" {
  description = "The IAM Policy objects of the Users inline policy."
  value       = try(aws_iam_user_policy.policy, null)
}

output "user_policy_attachment" {
  description = "The IAM User Policy Attachment objects."
  value       = try(aws_iam_user_policy_attachment.policy, null)
}

# ------------------------------------------------------------------------------
# OUTPUT ALL INPUT VARIABLES
# ------------------------------------------------------------------------------

output "names" {
  description = "The user names."
  value       = var.names
}

output "path" {
  description = "Path in which to create the user."
  value       = var.path
}

output "permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the user."
  value       = var.permissions_boundary
}

output "force_destroy" {
  description = "When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices."
  value       = var.force_destroy
}

output "tags" {
  description = "Key-value map of tags for the IAM user."
  value       = var.tags
}

output "policy_statements" {
  description = "List of IAM policy statements to attach to the User as an inline policy."
  value       = var.policy_statements
}

output "policy_arns" {
  description = "Set of IAM custom or managed policies ARNs attached to the User."
  value       = var.policy_arns
}

output "groups" {
  description = "List of IAM groups the users were added to."
  value       = var.groups
}

# ------------------------------------------------------------------------------
# OUTPUT MODULE CONFIGURATION
# ------------------------------------------------------------------------------
output "module_enabled" {
  description = "Whether the module is enabled"
  value       = var.module_enabled
}
