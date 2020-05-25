# ------------------------------------------------------------------------------
# AWS IAM USER
# This module creates a single AWS IAM USER
# You can attach an inline policy and/or custom/managed policies through their ARNs
# You can add the user to a list of groups (use module_depends_on to depend on group resources)
# ------------------------------------------------------------------------------

resource "aws_iam_user" "user" {
  for_each = var.module_enabled ? var.names : []

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
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_user_policy" "policy" {
  for_each = local.policy_enabled ? aws_iam_user.user : {}

  policy = data.aws_iam_policy_document.policy[0].json
  name   = each.value.name
  user   = each.value.name

  depends_on = [var.module_depends_on]
}

locals {
  policy_arns = tolist(setproduct(var.names, var.policy_arns))
}

# Attach custom or managed policies
resource "aws_iam_user_policy_attachment" "policy" {
  count = var.module_enabled ? length(local.policy_arns) : 0

  user       = local.policy_arns[count.index][0]
  policy_arn = local.policy_arns[count.index][1]

  depends_on = [
    var.module_depends_on,
    aws_iam_user.user,
  ]
}

# add the user to a list of groups
resource "aws_iam_user_group_membership" "group" {
  for_each = var.module_enabled ? var.names : []

  user   = aws_iam_user.user[each.key].name
  groups = var.groups

  depends_on = [var.module_depends_on]
}
