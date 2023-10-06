provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example_user_count" {
  count = 3
  name = "clau_${count.index}"
}

resource "aws_iam_user" "example_user_foreach" {
  for_each = toset(var.user_names)
  name = each.value
}