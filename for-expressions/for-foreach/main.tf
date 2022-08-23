# Define provider
provider "aws" {
  region = "us-east-1"
}

variable "users" {
  description = "IAM users names"
  type = set(string)
}

resource "aws_iam_user" "test" {
  for_each = var.users
  name = "user-${each.value}"
}

# Print user arn
output "arn_user" {
  description = "User ARN carlos"
  value = aws_iam_user.test["carlos"].arn
}

# Print list users arn
output "arn_all_users" {
  description = "All users ARN"
  value = [for user in aws_iam_user.test : user.arn]
}

# Print a map with user name and arn
output "arn_name_to_arn" {
  description = "All users ARN"
  value = {for user in aws_iam_user.test : user.name => user.arn}
}

# Print a list with all user names
output "all_user_names" {
    description = "All user names"
    value = [for user in aws_iam_user.test : user.name]
}