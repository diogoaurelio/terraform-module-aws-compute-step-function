variable "aws_region" {
  description = "AWS Region"
}

variable "aws_account_id" {
  description = "AWS Account ID"
}

variable "environment" {
  description = "Environment of the Stack"
  default     = "dev"
}

variable "project" {
  default = "vw-analytics"
}

variable "state_machine_name" {}

variable "aws_sfn_state_machine_definition" {}

variable "attach_additional_policy" {
  description = "Set this to true if using the policy variable"
  default     = false
}

variable "additional_policy" {
  default = ""
}

variable "state_machine_description" {
  default = "Fires REST Lambda State Machine"
}

variable "state_machine_schedule_expression" {
  description = "Periodicity that Cloudwatch triggers State Step-function execution"
}

variable "state_machine_execution_data" {
  description = "Param passed to lambda function"
}
