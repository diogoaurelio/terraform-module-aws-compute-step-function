Terraform AWS module for Step Function setup
============================================

Generic repository for a terraform module for AWS Step Function

![Image of Terraform](https://i.imgur.com/Jj2T26b.jpg)

# Table of content

- [Introduction](#intro)
- [Usage](#usage)
- [Release log](#release-log)
- [Module versioning & git](#module-versioning-&-git)
- [Local terraform setup](#local-terraform-setup)
- [Authors/Contributors](#authorscontributors)


# Intro

Module to create a AWS step function/state-machine with the following details:
- AWS IAM role to be used by state machine
- AWS Cloudwatch trigger to invoke the step function
- AWS Step function/state-machine

Optionally:
- Accepts additional IAM policy defined outside to enhance state machine permissions

# Usage

Example usage:

```hcl

// Example policy to allow Step Function to invoke a Lambda function
data "aws_iam_policy_document" "state_machine_policy" {
  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      // substitute here your lambda ARN
      "aws_lambda_function_arn",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "cloudwatch:PutMetricData",
    ]

    resources = ["*"]
  }
}

data "template_file" "state_machine_definition" {
  // optionally substitute your lambda function ARN, to be injected on your step function template file
  vars {
    aws_lambda_function_arn          = "aws_lambda_function_arn"
  }
  // adjust here your template JSON definition
  template = "${file("${path.module}/templates/basic-lambda-state-machine.tpl")}"
}

module "state_machine" {
  source                            = "github.com/diogoaurelio/terraform-module-aws-compute-step-function"
    version                         = "v0.0.1"
  aws_region                        = "eu-west-1"
  aws_account_id                    = "${data.aws_caller_identity.current.account_id}"
  environment                       = "dev"
  project                           = "analytics"
  aws_sfn_state_machine_definition  = "${data.template_file.state_machine_definition.rendered}"
  state_machine_execution_data      = "some-parameter-that-will-be-injected-into-first-state-machine"
  state_machine_name                = "my-state-machine"
  state_machine_schedule_expression = "rate(1 day)"
  additional_policy                 = "${data.aws_iam_policy_document.state_machine_policy.json}"
  attach_additional_policy          = true
}


```


# Release log

Whenever you bump this module's version, please add a summary description of the changes performed, so that collaboration across developers becomes easier.

* version v0.0.1 - first module release

# Module versioning & git

To update this module please follow the following proceedure:

1) make your changes following the normal git workflow
2) after merging the your changes to master, comes the most important part, namely versioning using tags:

```bash
git tag v0.0.2
```

3) push the tag to the remote git repository:
```bash
git push origin master tag v0.0.2
```

# Local terraform setup

* [Install Terraform](https://www.terraform.io/)

```bash
brew install terraform
```

* In order to automatic format terraform code (and have it cleaner), we use pre-commit hook. To [install pre-commit](https://pre-commit.com/#install).
* Run [pre-commit install](https://pre-commit.com/#usage) to setup locally hook for terraform code cleanup.

```bash
pre-commit install
```


# Authors/Contributors

See the list of [contributors](https://github.com/diogoaurelio/terraform-module-aws-compute-step-function/graphs/contributors) who participated in this project.