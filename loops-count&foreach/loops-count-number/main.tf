# Define provider
provider "aws" {
    region = "us-east-1"
}

# Create a <var.users> of IAM
resource "aws_iam_user" "test" {
  count = 2
  name = "user-test.${count.index}"
}