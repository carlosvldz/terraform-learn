# Define provider
provider "aws" {
  region = "us-east-1"
}

variable "users" {
  description = "IAM user names"
  type = set(string)
}

resource "aws_iam_user" "test" {
  for_each = var.users
  name = "user-${each.value}"
}