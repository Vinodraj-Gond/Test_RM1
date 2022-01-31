variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "zones" {
  type    = list(any)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "ec2_root_volume_size" {
  type = number
}

variable "ec2_root_volume_type" {
  type = string
}

variable "r53_hosted_zone_id" {
  type = string
}

variable "r53_record" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "private_subnet_id" {}
variable "public1_subnet_id" {}
variable "public2_subnet_id" {}

variable "certificate_arn" {}

