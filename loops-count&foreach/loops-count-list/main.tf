# Define provider
provider "aws" {
  region = "us-east-1"
}

# Define number of users to create
variable "users" {
  description = "IAM user names"
  type = list(string)
}

# Create a <var.users> of IAM
resource "aws_iam_user" "test" {
  count = length(var.users)
  name = "user-${var.users[count.index]}"
}