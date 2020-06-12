[<img src="https://raw.githubusercontent.com/mineiros-io/brand/3bffd30e8bdbbde32c143e2650b2faa55f1df3ea/mineiros-primary-logo.svg" width="400"/>][homepage]

[![license][badge-license]][apache20]
[![Terraform Version][badge-terraform]][releases-terraform]
[![Join Slack][badge-slack]][slack]

# terraform-aws-iam-user Example

## Basic usage

The code in [main.tf] defines an example for creating three users and attaching two IAM policies to each of them.

```hcl
module "iam-users" {
  source = "git@github.com:mineiros-io/terraform-aws-iam-user.git?ref=v0.0.3"

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

## Running the example

### Cloning the repository

```bash
git clone https://github.com/mineiros-io/terraform-aws-iam-user.git
cd terraform-aws-iam-user/terraform/examples/simple-users
```

### Initializing Terraform

Run `terraform init` to initialize the example. The output should look like:

```hcl
Initializing modules...
Downloading git@github.com:mineiros-io/terraform-aws-iam-user.git?ref=v0.0.3 for iam-users...
- iam-users in .terraform/modules/iam-users

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "aws" (hashicorp/aws) 2.64.0...

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

### Planning the example

Run `terraform plan` to preview the creation of the resources. Attention: We are not creating a plan output file in this case. In a production environment, it would be recommended to create a plan file first that can be applied in an isolated apply run.

```hcl
Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.


------------------------------------------------------------------------

An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.iam-users.aws_iam_user.user["user.one"] will be created
  + resource "aws_iam_user" "user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "user.one"
      + path          = "/"
      + unique_id     = (known after apply)
    }

  # module.iam-users.aws_iam_user.user["user.three"] will be created
  + resource "aws_iam_user" "user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "user.three"
      + path          = "/"
      + unique_id     = (known after apply)
    }

  # module.iam-users.aws_iam_user.user["user.two"] will be created
  + resource "aws_iam_user" "user" {
      + arn           = (known after apply)
      + force_destroy = false
      + id            = (known after apply)
      + name          = "user.two"
      + path          = "/"
      + unique_id     = (known after apply)
    }

  # module.iam-users.aws_iam_user_policy_attachment.policy[0] will be created
  + resource "aws_iam_user_policy_attachment" "policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      + user       = "user.one"
    }

  # module.iam-users.aws_iam_user_policy_attachment.policy[1] will be created
  + resource "aws_iam_user_policy_attachment" "policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
      + user       = "user.one"
    }

  # module.iam-users.aws_iam_user_policy_attachment.policy[2] will be created
  + resource "aws_iam_user_policy_attachment" "policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      + user       = "user.three"
    }

  # module.iam-users.aws_iam_user_policy_attachment.policy[3] will be created
  + resource "aws_iam_user_policy_attachment" "policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
      + user       = "user.three"
    }

  # module.iam-users.aws_iam_user_policy_attachment.policy[4] will be created
  + resource "aws_iam_user_policy_attachment" "policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
      + user       = "user.two"
    }

  # module.iam-users.aws_iam_user_policy_attachment.policy[5] will be created
  + resource "aws_iam_user_policy_attachment" "policy" {
      + id         = (known after apply)
      + policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
      + user       = "user.two"
    }

Plan: 12 to add, 0 to change, 0 to destroy.

------------------------------------------------------------------------

Note: You didn't specify an "-out" parameter to save this plan, so Terraform
can't guarantee that exactly these actions will be performed if
"terraform apply" is subsequently run.
```

### Applying the example

Run `terraform apply -auto-approve` to create the resources. Attention: this will not ask for confirmation and also not use the previously run plan as no plan output file was used.

### Destroying the example

Run `terraform destroy -refresh=false -auto-approve` to destroy all previously created resources again.

<!-- References -->

[homepage]: https://mineiros.io/?ref=terraform-aws-iam-user

[badge-license]: https://img.shields.io/badge/license-Apache%202.0-brightgreen.svg
[badge-terraform]: https://img.shields.io/badge/terraform-0.13%20and%200.12.20+-623CE4.svg?logo=terraform
[badge-slack]: https://img.shields.io/badge/slack-@mineiros--community-f32752.svg?logo=slack

[releases-terraform]: https://github.com/hashicorp/terraform/releases
[apache20]: https://opensource.org/licenses/Apache-2.0
[slack]: https://join.slack.com/t/mineiros-community/shared_invite/zt-ehidestg-aLGoIENLVs6tvwJ11w9WGg

[main.tf]: https://github.com/mineiros-io/terraform-aws-iam-user/blob/master/examples/simple-users/main.tf
