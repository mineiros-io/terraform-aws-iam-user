# ------------------------------------------------------------------------------
# AWS IAM USER
# This module creates a single AWS IAM USER
# You can attach an inline policy and/or custom/managed policies via ther ARNs
# You can add the user to a list of groups (use module_depends_on to depend on group resources)
# ------------------------------------------------------------------------------
resource "aws_iam_user" "user" {
  for_each = var.module_enabled ? [var.name] : []

  name                 = each.key
  path                 = var.path
  permissions_boundary = var.permissions_boundary
  force_destroy        = var.force_destroy
  tags                 = var.tags

  depends_on = [var.module_depends_on]
}

locals {
  policy_enabled = var.module_enabled && length(var.policy_statements) > 0
}

data "aws_iam_policy_document" "policy" {
  count = local.policy_enabled ? 1 : 0

  dynamic "statement" {
    for_each = var.policy_statements

    content {
      actions   = try(statement.value.actions, null)
      effect    = try(statement.value.effect, null)
      resources = try(statement.value.resources, null)
      sid       = try(statement.value.sid, null)
    }
  }
}

resource "aws_iam_user_policy" "policy" {
  count = local.policy_enabled ? 1 : 0

  policy = data.aws_iam_policy_document.policy[0].json
  name   = var.name
  user   = aws_iam_user.user[0].name

  depends_on = [var.module_depends_on]
}

# Attach custom or managed policies
resource "aws_iam_user_policy_attachment" "policy" {
  count = var.module_enabled ? length(var.policy_arns) : 0

  user       = aws_iam_user.user[0].name
  policy_arn = var.policy_arns[count.index]

  depends_on = [var.module_depends_on]
}

# add the user to a list of groups
resource "aws_iam_user_group_membership" "group" {
  count = var.module_enabled && length(var.groups) > 0 ? 1 : 0

  user   = aws_iam_user.user[0].name
  groups = var.groups

  depends_on = [var.module_depends_on]
}
