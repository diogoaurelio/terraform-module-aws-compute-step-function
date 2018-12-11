output "aws_iam_role_name" {
  value = "${aws_iam_role.this.name}"
}

output "aws_iam_role_arn" {
  value = "${aws_iam_role.this.arn}"
}

output "aws_iam_role_id" {
  value = "${aws_iam_role.this.id}"
}

output "aws_iam_role_create_date" {
  value = "${aws_iam_role.this.create_date}"
}

output "aws_sfn_state_machine_id" {
  value = "${aws_sfn_state_machine.this.id}"
}

output "aws_sfn_state_machine_name" {
  value = "${aws_sfn_state_machine.this.name}"
}

output "aws_sfn_state_machine_creation_date" {
  value = "${aws_sfn_state_machine.this.creation_date}"
}

output "aws_sfn_state_machine_definition" {
  value = "${aws_sfn_state_machine.this.definition}"
}

output "aws_sfn_state_machine_role_arn" {
  value = "${aws_sfn_state_machine.this.role_arn}"
}

output "aws_iam_policy_base_policy_name" {
  value = "${aws_iam_policy.base_policy.name}"
}

output "aws_iam_policy_base_policy_arn" {
  value = "${aws_iam_policy.base_policy.arn}"
}

output "aws_iam_policy_base_policy_policy" {
  value = "${aws_iam_policy.base_policy.policy}"
}

output "aws_cloudwatch_event_rule_name" {
  value = "${element(concat(aws_cloudwatch_event_rule.this.*.name, list("")), 0)}"
}

output "aws_cloudwatch_event_rule_arn" {
  value = "${element(concat(aws_cloudwatch_event_rule.this.*.arn, list("")), 0)}"
}

output "aws_cloudwatch_event_rule_schedule_expression" {
  value = "${element(concat(aws_cloudwatch_event_rule.this.*.schedule_expression, list("")), 0)}"
}

output "aws_cloudwatch_event_target_arn" {
  value = "${element(concat(aws_cloudwatch_event_target.this.*.arn, list("")), 0)}"
}

output "aws_cloudwatch_event_target_id" {
  value = "${element(concat(aws_cloudwatch_event_target.this.*.id, list("")), 0)}"
}
