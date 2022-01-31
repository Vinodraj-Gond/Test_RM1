resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "local" {
  key_name   = "aquila_key_${random_id.postfix.hex}"
  public_key = tls_private_key.generated_key.public_key_openssh
}

resource "aws_iam_instance_profile" "aquila_instance_profile" {
  name = "aquila_instance_profile_${random_id.postfix.hex}"
  role = aws_iam_role.aquila_role.name
}

resource "aws_instance" "aquila" {
  iam_instance_profile   = aws_iam_instance_profile.aquila_instance_profile.name
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.local.key_name
  vpc_security_group_ids = [aws_security_group.aquila_instance_sg.id]
  subnet_id              = var.private_subnet_id

  root_block_device {
    volume_size = var.ec2_root_volume_size
    volume_type = var.ec2_root_volume_type
  }

  tags = {
    "project" = "aquila"
    "Name"    = "aquila_instance_${random_id.postfix.hex}"
  }
}

resource "local_file" "generated_key" {
  content  = tls_private_key.generated_key.private_key_pem
  filename = "aquila_pk.pem"
}
