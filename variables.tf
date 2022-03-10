variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  description = "The profile name"
}

variable "role_arn" {
  description = "The arn of the role"
}

variable "acc_id" {
  description = "account id"
}

variable "app_name" {
  description = "app name"
}

variable "group_name" {
  description = "deploy group name"
}