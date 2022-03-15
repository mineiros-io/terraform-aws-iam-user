header {
  image = "https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg"
  url   = "https://mineiros.io/?ref=terraform-aws-iam-user"

  badge "build" {
    image = "https://github.com/mineiros-io/terraform-aws-iam-user/workflows/CI/CD%20Pipeline/badge.svg"
    url   = "https://github.com/mineiros-io/terraform-aws-iam-user/actions"
    text  = "Build Status"
  }

  badge "semver" {
    image = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-user.svg?label=latest&sort=semver"
    url   = "https://github.com/mineiros-io/terraform-aws-iam-user/releases"
    text  = "GitHub tag (latest SemVer)"
  }

  badge "terraform" {
    image = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
    url   = "https://github.com/hashicorp/terraform/releases"
    text  = "Terraform Version"
  }

  badge "tf-aws-provider" {
    image = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
    url   = "https://github.com/terraform-providers/terraform-provider-aws/releases"
    text  = "AWS Provider Version"
  }

  badge "slack" {
    image = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
    url   = "https://mineiros.io/slack"
    text  = "Join Slack"
  }
}

section {
  title   = "terraform-aws-iam-user"
  toc     = true
  content = <<-END
    A [Terraform](https://www.terraform.io) base module for deploying and managing
    [IAM Users][IAM-User-Docs] on [Amazon Web Services][AWS].

    ***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
    and is compatible with the terraform AWS provider v3 as well as v2.0 and above.***
  END

  section {
    title   = "Module Features"
    content = <<-END
      In contrast to the plain `aws_iam_user` resource, this module has extended features allowing you
      to add custom & managed IAM and/or inline policies and adding user to groups.
      While all security features can be disabled as needed, best practices
      are pre-configured.

      - **Standard Module Features**:

        Add IAM users

      - **Extended Module Features**:
        Attach custom & managed IAM policies,
        attach an inline policy,
        add users to a set of groups
    END
  }

  section {
    title   = "Getting Started"
    content = <<-END
      Most basic usage showing how to add three users and assigning two policies:

      ```hcl
      module "iam-users" {
        source  = "mineiros-io/iam-user/aws"
        version = "~> 0.5.1"

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
      ```
    END
  }

  section {
    title   = "Module Argument Reference"
    content = <<-END
      See
      [variables.tf]
      and
      [examples]
      for details and use-cases.
    END

    section {
      title = "Module Configuration"

      variable "module_enabled" {
        type        = bool
        default     = true
        description = <<-END
          Specifies whether resources in the module will be created.
        END
      }

      variable "module_depends_on" {
        type        = list(dependency)
        description = <<-END
          A set of dependencies. Any object can be assigned to this list to define a hidden external dependency.
        END
      }
    }

    section {
      title = "Top-level Arguments"

      section {
        title = "Main Resource Configuration"

        variable "names" {
          required    = true
          type        = set(string)
          description = <<-END
            A set of names of IAM users that will be created. Forces new resource.
          END
        }

        variable "groups" {
          type        = set(string)
          default     = []
          description = <<-END
            A set of IAM groups to add the user(s) to.
          END
        }

        variable "force_destroy" {
          type        = bool
          default     = false
          description = <<-END
            When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed.
          END
        }

        variable "path" {
          type        = string
          default     = "/"
          description = <<-END
            The path in which to create the user(s). See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names) for more information.
          END
        }

        variable "permissions_boundary" {
          type        = string
          description = <<-END
            The ARN of the policy that is used to set the permissions boundary for the user.
            Default is not to set any boundary.
          END
        }

        variable "tags" {
          type        = map(string)
          default     = {}
          description = <<-END
            Key-value map of tags for the IAM user.
          END
        }
      }

      section {
        title = "Extended Resource configuration"

        section {
          title = "Custom & Managed Policies"

          variable "policy_arns" {
            type        = list(string)
            default     = []
            description = <<-END
              List of custom or managed IAM policy ARNs to attach to the user.
            END
          }
        }

        section {
          title = "Inline Policy"

          variable "policy_statements" {
            type           = list(statement)
            default        = []
            description    = <<-END
              List of IAM policy statements to attach to the user as an inline policy.
            END
            readme_example = <<-END
              policy_statements = [
                {
                  sid = "FullS3Access"

                  effect = "Allow"

                  actions     = ["s3:*"]
                  not_actions = []

                  resources     = ["*"]
                  not_resources = []

                  conditions = [
                    {
                      test     = "Bool"
                      variable = "aws:MultiFactorAuthPresent"
                      values   = ["true"]
                    }
                  ]
                }
              ]
            END
          }
        }
      }
    }
  }

  section {
    title   = "Module Outputs"
    content = <<-END
      The following attributes are exported by the module:
    END

    output "users" {
      type        = list(user)
      description = <<-END
        The `aws_iam_user` object(s).
      END
    }

    output "user_policy" {
      type        = object(user_policy)
      description = <<-END
        The `aws_iam_user_policy` object(s).
      END
    }

    output "user_policy_attachment" {
      type        = object(user_policy_attachment)
      description = <<-END
        The `aws_iam_user_policy_attachment` object(s).
      END
    }

    output "names" {
      type        = set(string)
      description = <<-END
        The user names.
      END
    }

    output "path" {
      type        = string
      description = <<-END
        Path in which to create the user.
      END
    }

    output "permissions_boundary" {
      type        = string
      description = <<-END
        The ARN of the policy that is used to set the permissions boundary for
        the user.
      END
    }

    output "force_destroy" {
      type        = bool
      description = <<-END
        When destroying this user, destroy even if it has non-Terraform-managed
        IAM access keys, login profile or MFA devices.
      END
    }

    output "tags" {
      type        = map(string)
      description = <<-END
        Key-value map of tags for the IAM user.
      END
    }

    output "policy_statements" {
      type        = list(policy_statement)
      description = <<-END
        List of IAM policy statements to attach to the User as an inline policy.
      END
    }

    output "policy_arns" {
      type        = set(string)
      description = <<-END
        Set of IAM custom or managed policies ARNs attached to the User.
      END
    }

    output "groups" {
      type        = list(string)
      description = <<-END
        List of IAM groups the users were added to.
      END
    }
  }

  section {
    title = "External Documentation"

    section {
      title   = "AWS Documentation IAM"
      content = <<-END
        - User: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
        - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html
      END
    }

    section {
      title   = "Terraform AWS Provider Documentation"
      content = <<-END
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment
        - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership
      END
    }
  }

  section {
    title   = "Module Versioning"
    content = <<-END
      This Module follows the principles of [Semantic Versioning (SemVer)].

      Given a version number `MAJOR.MINOR.PATCH`, we increment the:

      1. `MAJOR` version when we make incompatible changes,
      2. `MINOR` version when we add functionality in a backwards compatible manner, and
      3. `PATCH` version when we make backwards compatible bug fixes.
    END

    section {
      title   = "Backwards compatibility in `0.0.z` and `0.y.z` version"
      content = <<-END
        - Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
        - Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)
      END
    }
  }

  section {
    title   = "About Mineiros"
    content = <<-END
      Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
      We offer commercial support for all of our projects and encourage you to reach out
      if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

      We can also help you with:

      - Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
      - Consulting & training on AWS, Terraform and DevOps
    END
  }

  section {
    title   = "Reporting Issues"
    content = <<-END
      We use GitHub [Issues] to track community reported issues and missing features.
    END
  }

  section {
    title   = "Contributing"
    content = <<-END
      Contributions are always encouraged and welcome! For the process of accepting changes, we use
      [Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].
    END
  }

  section {
    title   = "Makefile Targets"
    content = <<-END
      This repository comes with a handy [Makefile].
      Run `make help` to see details on each available target.
    END
  }

  section {
    title   = "License"
    content = <<-END
      [![license][badge-license]][apache20]

      This module is licensed under the Apache License Version 2.0, January 2004.
      Please see [LICENSE] for full details.

      Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]
    END
  }
}

references {
  ref "homepage" {
    value = "https://mineiros.io/?ref=terraform-aws-iam-user"
  }
  ref "hello@mineiros.io" {
    value = "mailto:hello@mineiros.io"
  }
  ref "badge-build" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/workflows/CI/CD%20Pipeline/badge.svg"
  }
  ref "badge-semver" {
    value = "https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-user.svg?label=latest&sort=semver"
  }
  ref "badge-license" {
    value = "https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg"
  }
  ref "badge-terraform" {
    value = "https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform"
  }
  ref "badge-slack" {
    value = "https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack"
  }
  ref "badge-tf-aws" {
    value = "https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform"
  }
  ref "releases-aws-provider" {
    value = "https://github.com/terraform-providers/terraform-provider-aws/releases"
  }
  ref "build-status" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/actions"
  }
  ref "releases-github" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/releases"
  }
  ref "releases-terraform" {
    value = "https://github.com/hashicorp/terraform/releases"
  }
  ref "apache20" {
    value = "https://opensource.org/licenses/Apache-2.0"
  }
  ref "slack" {
    value = "https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg"
  }
  ref "Terraform" {
    value = "https://www.terraform.io"
  }
  ref "AWS" {
    value = "https://aws.amazon.com/"
  }
  ref "IAM-User-Docs" {
    value = "https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html"
  }
  ref "Semantic Versioning (SemVer)" {
    value = "https://semver.org/"
  }
  ref "examples/example/main.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples/example/main.tf"
  }
  ref "variables.tf" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/variables.tf"
  }
  ref "examples/" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples"
  }
  ref "Issues" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/issues"
  }
  ref "LICENSE" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/LICENSE"
  }
  ref "Makefile" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/Makefile"
  }
  ref "Pull Requests" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/pulls"
  }
  ref "Contribution Guidelines" {
    value = "https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/CONTRIBUTING.md"
  }
}
