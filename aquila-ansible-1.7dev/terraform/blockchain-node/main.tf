terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "random_id" "postfix" {
  byte_length = 8
}
resource "random_id" "index" {
  byte_length = 2
}

locals {
 # subnet_ids_list         = tolist(data.aws_subnet_ids.current.ids)
  #subnet_ids_random_index = random_id.index.dec % length(data.aws_subnet_ids.current.ids)
 # instance_subnet_id      = local.subnet_ids_list[local.subnet_ids_random_index]
 subnet_ids_random_index = var.private_subnet_id
 instance_subnet_id      = var.private_subnet_id
}

resource "local_file" "IPOutput2" {
  content = templatefile("ip.tmpl", {
    ip_addr = local.instance_subnet_id,
    }
  )
  filename = "./ouput-ip.txt"
}