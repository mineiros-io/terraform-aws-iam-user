[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>](https://mineiros.io/?ref=terraform-aws-iam-user)

[![Build Status](https://github.com/mineiros-io/terraform-aws-iam-user/workflows/CI/CD%20Pipeline/badge.svg)](https://github.com/mineiros-io/terraform-aws-iam-user/actions)
[![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-user.svg?label=latest&sort=semver)](https://github.com/mineiros-io/terraform-aws-iam-user/releases)
[![Terraform Version](https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform)](https://github.com/hashicorp/terraform/releases)
[![AWS Provider Version](https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform)](https://github.com/terraform-providers/terraform-provider-aws/releases)
[![Join Slack](https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack)](https://mineiros.io/slack)

# terraform-aws-iam-user

A [Terraform](https://www.terraform.io) base module for deploying and managing
[IAM Users][IAM-User-Docs] on [Amazon Web Services][AWS].

***This module supports Terraform v1.x, v0.15, v0.14, v0.13 as well as v0.12.20 and above
and is compatible with the terraform AWS provider v3 as well as v2.0 and above.***


- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource configuration](#extended-resource-configuration)
      - [Custom & Managed Policies](#custom--managed-policies)
      - [Inline Policy](#inline-policy)
- [Module Outputs](#module-outputs)
- [External Documentation](#external-documentation)
  - [AWS Documentation IAM](#aws-documentation-iam)
  - [Terraform AWS Provider Documentation](#terraform-aws-provider-documentation)
- [Module Versioning](#module-versioning)
  - [Backwards compatibility in `0.0.z` and `0.y.z` version](#backwards-compatibility-in-00z-and-0yz-version)
- [About Mineiros](#about-mineiros)
- [Reporting Issues](#reporting-issues)
- [Contributing](#contributing)
- [Makefile Targets](#makefile-targets)
- [License](#license)

## Module Features

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

## Getting Started

Most basic usage showing how to add three users and assigning two policies:

```hcl
module "iam-users" {
  source  = "git@github.com:mineiros-io/terraform-aws-iam-user.git?ref=v0.5.1"

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

## Module Argument Reference

See
[variables.tf]
and
[examples]
for details and use-cases.

### Module Configuration

- [**`module_enabled`**](#var-module_enabled): *(Optional `bool`)*<a name="var-module_enabled"></a>

  Specifies whether resources in the module will be created.

  Default is `true`.

- [**`module_depends_on`**](#var-module_depends_on): *(Optional `set(object)`)*<a name="var-module_depends_on"></a>

  A set of dependencies. Any object can be assigned to this list to define a hidden external dependency.

### Top-level Arguments

#### Main Resource Configuration

- [**`names`**](#var-names): *(**Required** `set(string)`)*<a name="var-names"></a>

  A set of names of IAM users that will be created. Forces new resource.

- [**`groups`**](#var-groups): *(Optional `set(string)`)*<a name="var-groups"></a>

  A set of IAM groups to add the user(s) to.

  Default is `[]`.

- [**`force_destroy`**](#var-force_destroy): *(Optional `bool`)*<a name="var-force_destroy"></a>

  When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed.

  Default is `false`.

- [**`path`**](#var-path): *(Optional `string`)*<a name="var-path"></a>

  The path in which to create the user(s). See [IAM Identifiers](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names) for more information.

  Default is `"/"`.

- [**`permissions_boundary`**](#var-permissions_boundary): *(Optional `string`)*<a name="var-permissions_boundary"></a>

  The ARN of the policy that is used to set the permissions boundary for the user.
  Default is not to set any boundary.

- [**`tags`**](#var-tags): *(Optional `map(string)`)*<a name="var-tags"></a>

  Key-value map of tags for the IAM user.

  Default is `{}`.

#### Extended Resource configuration

##### Custom & Managed Policies

- [**`policy_arns`**](#var-policy_arns): *(Optional `list(string)`)*<a name="var-policy_arns"></a>

  List of custom or managed IAM policy ARNs to attach to the user.

  Default is `[]`.

##### Inline Policy

- [**`policy_statements`**](#var-policy_statements): *(Optional `list(statement)`)*<a name="var-policy_statements"></a>

  List of IAM policy statements to attach to the user as an inline policy.

  Default is `[]`.

  Example:

  ```hcl
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
  ```

## Module Outputs

The following attributes are exported by the module:

- [**`users`**](#output-users): *(`list(user)`)*<a name="output-users"></a>

  The `aws_iam_user` object(s).

- [**`user_policy`**](#output-user_policy): *(`object(user_policy)`)*<a name="output-user_policy"></a>

  The `aws_iam_user_policy` object(s).

- [**`user_policy_attachment`**](#output-user_policy_attachment): *(`object(user_policy_attachment)`)*<a name="output-user_policy_attachment"></a>

  The `aws_iam_user_policy_attachment` object(s).

- [**`names`**](#output-names): *(`set(string)`)*<a name="output-names"></a>

  The user names.

- [**`path`**](#output-path): *(`string`)*<a name="output-path"></a>

  Path in which to create the user.

- [**`permissions_boundary`**](#output-permissions_boundary): *(`string`)*<a name="output-permissions_boundary"></a>

  The ARN of the policy that is used to set the permissions boundary for
  the user.

- [**`force_destroy`**](#output-force_destroy): *(`bool`)*<a name="output-force_destroy"></a>

  When destroying this user, destroy even if it has non-Terraform-managed
  IAM access keys, login profile or MFA devices.

- [**`tags`**](#output-tags): *(`map(string)`)*<a name="output-tags"></a>

  Key-value map of tags for the IAM user.

- [**`policy_statements`**](#output-policy_statements): *(`list(policy_statement)`)*<a name="output-policy_statements"></a>

  List of IAM policy statements to attach to the User as an inline policy.

- [**`policy_arns`**](#output-policy_arns): *(`set(string)`)*<a name="output-policy_arns"></a>

  Set of IAM custom or managed policies ARNs attached to the User.

- [**`groups`**](#output-groups): *(`list(string)`)*<a name="output-groups"></a>

  List of IAM groups the users were added to.

## External Documentation

### AWS Documentation IAM

- User: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
- Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html

### Terraform AWS Provider Documentation

- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_policy_attachment
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user_group_membership

## Module Versioning

This Module follows the principles of [Semantic Versioning (SemVer)].

Given a version number `MAJOR.MINOR.PATCH`, we increment the:

1. `MAJOR` version when we make incompatible changes,
2. `MINOR` version when we add functionality in a backwards compatible manner, and
3. `PATCH` version when we make backwards compatible bug fixes.

### Backwards compatibility in `0.0.z` and `0.y.z` version

- Backwards compatibility in versions `0.0.z` is **not guaranteed** when `z` is increased. (Initial development)
- Backwards compatibility in versions `0.y.z` is **not guaranteed** when `y` is increased. (Pre-release)

## About Mineiros

Mineiros is a [DevOps as a Service][homepage] company based in Berlin, Germany.
We offer commercial support for all of our projects and encourage you to reach out
if you have any questions or need help. Feel free to send us an email at [hello@mineiros.io] or join our [Community Slack channel][slack].

We can also help you with:

- Terraform modules for all types of infrastructure such as VPCs, Docker clusters, databases, logging and monitoring, CI, etc.
- Consulting & training on AWS, Terraform and DevOps

## Reporting Issues

We use GitHub [Issues] to track community reported issues and missing features.

## Contributing

Contributions are always encouraged and welcome! For the process of accepting changes, we use
[Pull Requests]. If you'd like more information, please see our [Contribution Guidelines].

## Makefile Targets

This repository comes with a handy [Makefile].
Run `make help` to see details on each available target.

## License

[![license][badge-license]][apache20]

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020-2022 [Mineiros GmbH][homepage]


<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-user
[hello@mineiros.io]: mailto:hello@mineiros.io
[badge-build]: https://github.com/mineiros-io/terraform-aws-iam-user/workflows/CI/CD%20Pipeline/badge.svg
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-user.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-1.x%20|%200.15%20|%200.14%20|%200.13%20|%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack
[badge-tf-aws]: https://img.shields.io/badge/AWS-3%20and%202.0+-F8991D.svg?logo=terraform
[releases-aws-provider]: https://github.com/terraform-providers/terraform-provider-aws/releases
[build-status]: https://github.com/mineiros-io/terraform-aws-iam-user/actions
[releases-github]: https://github.com/mineiros-io/terraform-aws-iam-user/releases
[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg
[Terraform]: https://www.terraform.io
[AWS]: https://aws.amazon.com/
[IAM-User-Docs]: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
[Semantic Versioning (SemVer)]: https://semver.org/
[examples/example/main.tf]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples/example/main.tf
[variables.tf]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/variables.tf
[examples/]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples
[Issues]: https://github.com/mineiros-io/terraform-aws-iam-user/issues
[LICENSE]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/LICENSE
[Makefile]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/Makefile
[Pull Requests]: https://github.com/mineiros-io/terraform-aws-iam-user/pulls
[Contribution Guidelines]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/CONTRIBUTING.md
