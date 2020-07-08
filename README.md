[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![Build Status][badge-build]][build-status]
[![GitHub tag (latest SemVer)][badge-semver]][releases-github]
[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-iam-user

A [Terraform](https://www.terraform.io) module for deploying and managing
[IAM Users][IAM-User-Docs] on [Amazon Web Services][AWS].

- [Module Features](#module-features)
- [Getting Started](#getting-started)
- [Module Argument Reference](#module-argument-reference)
  - [Module Configuration](#module-configuration)
  - [Top-level Arguments](#top-level-arguments)
    - [Main Resource Configuration](#main-resource-configuration)
    - [Extended Resource configuration](#extended-resource-configuration)
      - [Custom & Managed Policies](#custom--managed-policies)
      - [Inline Policy](#inline-policy)
- [Module Attributes Reference](#module-attributes-reference)
- [External Documentation](#external-documentation)
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
  source  = "mineiros-io/iam-user/aws"
  version = "~> 0.1.0"

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

- **`module_enabled`**: *(Optional `bool`)*

  Specifies whether resources in the module will be created.
  Default is `true`.

- **`module_depends_on`**: *(Optional `set(any)`)*

  A set of dependencies. Any object can be assigned to this list to define a hidden external dependency.

### Top-level Arguments

#### Main Resource Configuration

- **`names`**: **(Required set(`string`), forces new resource)**

  A set of names of IAM users that will be created.

- **`groups`**: *(Optional set(`string`))*

  A set of IAM groups to add the user(s) to.
  Default is `[]`.

- **`force_destroy`**: *(Optional `bool`)*

  When destroying this user, destroy even if it has non-Terraform-managed IAM access keys, login profile or MFA devices. Without force_destroy a user with non-Terraform-managed access keys and login profile will fail to be destroyed.
  Default is `false`.

- **`path`**: *(Optional `string`)*

  The path in which to create the user(s). See [IAM Identifiers] for more information.
  Default is `/`.

[IAM Identifiers]: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_identifiers.html#identifiers-friendly-names

- **`permissions_boundary`**: *(Optional `string(arn)`)*

  The ARN of the policy that is used to set the permissions boundary for the user.
  Default is not to set any boundary.

- **`tags`**: *(Optional `map(string)`)*

  Key-value map of tags for the IAM user.
  Default is `{}`.

#### Extended Resource configuration

##### Custom & Managed Policies

- **`policy_arns`**: *(Optional `list(string)`)*

  List of custom or managed IAM policy ARNs to attach to the user.
  Default is `[]`.

##### Inline Policy

- **`policy_statements`**: *(Optional `list(statement)`)*

  List of IAM policy statements to attach to the user as an inline policy.
  Default is `[]`.

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

## Module Attributes Reference

The following attributes are exported by the module:

- **`users`**: The `aws_iam_user` object(s).
- **`user_policy`**: The `aws_iam_user_policy` object(s).

## External Documentation

- AWS Documentation IAM:
  - User: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users.html
  - Policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies.html

- Terraform AWS Provider Documentation:
  - https://www.terraform.io/docs/providers/aws/r/iam_user.html
  - https://www.terraform.io/docs/providers/aws/r/iam_user_policy.html
  - https://www.terraform.io/docs/providers/aws/r/iam_user_policy_attachment.html
  - https://www.terraform.io/docs/providers/aws/r/iam_user_group_membership.html

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

This module is licensed under the Apache License Version 2.0, January 2004.
Please see [LICENSE] for full details.

Copyright &copy; 2020 [Mineiros GmbH][homepage]

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-user
[hello@mineiros.io]: mailto:hello@mineiros.io

[badge-build]: https://mineiros.semaphoreci.com/badges/terraform-aws-iam-user/branches/master.svg?style=shields&key=e7037b28-8872-4dff-8ce1-484d8a971e8a
[badge-semver]: https://img.shields.io/github/v/tag/mineiros-io/terraform-aws-iam-user.svg?label=latest&sort=semver
[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[build-status]: https://mineiros.semaphoreci.com/projects/terraform-aws-iam-user
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
