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
  description = "User 3 ARN (index 2)"
  value = aws_iam_user.test[2].arn
}

# Print all users arn or names using splat
output "arn_all_users" {
  description = "All users ARN"
  value = aws_iam_user.test[*].name
}