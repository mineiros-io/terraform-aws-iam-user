# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.5.1]

### Fixed

- Add support for using computed values in `policy_arns` argument.

## [0.5.0]

### Added

- Add support for Terraform `1.x`

## [0.4.0]

### Added

- Add support for Terraform `v0.15`

### Changed

- Upgrade terratest to `v1.34.0`
- Update secrets in GitHub Actions pipeline
- Upgrade build-tools to `v0.11.0`
- Upgrade pre-commit-hooks to `v0.2.3`

## [0.3.0]

### Added

- Add support for Terraform v0.14.x

## [0.2.0]

### Added

- Add support for Terraform v0.13.x
- Add support for Terraform AWS Provider v3.x
- Prepare support for Terraform v0.14.x

## [0.1.0] - 2020-07-08

### Added

- Add CHANGELOG.md

### Changed

- Align documentation to latest structure and style

## [0.0.4] - 2020-06-18

### Added

- Add a unit tests

### Changed

- Align repository to latest structure and style

## [0.0.3] - 2020-06-18

### Fixed

- Fix creation of empty group resources

## [0.0.2] - 2020-05-25

### Added

- Add support for adding multiple users at once

## [0.0.1] - 2020-05-25

### Added

- Add IAM user support
- Add IAM user inline policy support
- Add custom or managed policies support
- Add support to attach the user to a list of groups by group name

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.5.1...HEAD
[0.5.1]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.5.0...v0.5.1

<!-- markdown-link-check-disabled -->

[0.5.0]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.0.4...v0.1.0
[0.0.4]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.0.3...v0.0.4
[0.0.3]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.0.2...v0.0.3
[0.0.2]: https://github.com/mineiros-io/terraform-aws-iam-user/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-aws-iam-user/releases/tag/v0.0.1
