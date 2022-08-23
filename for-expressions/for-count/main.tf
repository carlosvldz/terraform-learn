provider "aws" {
    region = "us-east-1"
}

variable "users" {
    description = "IAM users number"
    type = number
}

resource "aws_iam_user" "test" {
  count = var.users
  name = "user.${count.index}"
}

output "arn_user" {
  description = "User 2 ARN (index 1)"
  value = aws_iam_user.test[1].arn
}

output "arn_all_users" {
  description = "All users ARN"
  value = [for user in aws_iam_user.test : user.arn]
}