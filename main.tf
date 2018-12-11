# Creating IAM for state machine

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["states.amazonaws.com"]
      type        = "Service"
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["events.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.environment}-${var.project}-${var.state_machine_name}-state-machine-role" #"vw-analytics-platform-iam-for-state-machine"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

# provides step function state machine resource
resource "aws_sfn_state_machine" "this" {
  name       = "${var.environment}-${var.project}-${var.state_machine_name}-state-machine"
  role_arn   = "${aws_iam_role.this.arn}"
  definition = "${var.aws_sfn_state_machine_definition}"
}

data "aws_iam_policy_document" "base_policy" {
  statement {
    effect = "Allow"

    actions = [
      "states:DescribeStateMachine",
      "states:StartExecution",
      "states:ListExecutions",
      "states:UpdateStateMachine",
    ]

    resources = [
      "${aws_sfn_state_machine.this.id}",
    ]
  }
}

# IAM policy to allow execution of state machine
resource "aws_iam_policy" "base_policy" {
  name   = "${var.environment}-${var.project}-${var.state_machine_name}-base--state-machine-policy"
  policy = "${data.aws_iam_policy_document.base_policy.json}"
}

# Attach State Machine policy to Lambda IAM role
resource "aws_iam_policy_attachment" "base_policy" {
  name       = "vw-analytics-platform-iam-for-lamba-state-machine-policy-attachment"
  roles      = ["${aws_iam_role.this.name}"]
  policy_arn = "${aws_iam_policy.base_policy.arn}"
}

# Possibility to attach another policy document
resource "aws_iam_policy" "this_additional" {
  count = "${var.attach_additional_policy ? 1 : 0}"

  name   = "${var.environment}-${var.project}-${var.state_machine_name}-policy"
  policy = "${var.additional_policy}"
}

resource "aws_iam_policy_attachment" "this_additional" {
  count = "${var.attach_additional_policy ? 1 : 0}"

  name       = "${var.environment}-${var.project}-${var.state_machine_name}-policy-attach"
  roles      = ["${aws_iam_role.this.name}"]
  policy_arn = "${aws_iam_policy.this_additional.arn}"
}

# CloudWatch event trigger that starts the step function that executes the lambdas function
resource "aws_cloudwatch_event_rule" "this" {
  count               = "${length(var.state_machine_schedule_expression) > 0 ? 1 : 0}"
  name                = "${aws_sfn_state_machine.this.name}-trigger"
  description         = "${var.state_machine_description}"
  schedule_expression = "${var.state_machine_schedule_expression}"
}

resource "aws_cloudwatch_event_target" "this" {
  count     = "${length(var.state_machine_schedule_expression) > 0 ? 1 : 0}"
  rule      = "${element(aws_cloudwatch_event_rule.this.*.name, 0)}"
  target_id = "${aws_sfn_state_machine.this.name}"
  arn       = "${aws_sfn_state_machine.this.id}"
  role_arn  = "${aws_iam_role.this.arn}"

  input = <<DOC
    {
        "data": {
            "execution": "${var.state_machine_execution_data}"
        }
    }
    DOC
}
