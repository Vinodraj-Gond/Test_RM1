data "aws_vpc" "current" {
  id = var.vpc_id
}

data "aws_subnet" "current" {
  id = var.private_subnet_id
}
 data"aws_subnet" "public1" {
  id = var.public1_subnet_id
 }

data"aws_subnet" "public2" {
  id = var.public2_subnet_id
 }
