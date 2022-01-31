resource "aws_efs_file_system" "aquila_efs" {
  creation_token   = "aquila_efs_${random_id.postfix.hex}"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    "project" = "aquila"
  }
}

resource "aws_efs_file_system_policy" "policy" {
  file_system_id = aws_efs_file_system.aquila_efs.id

  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "EnforceInTransitEncryptionForAllClients",
    "Statement": [
      {
        "Sid": "Statement00",
        "Effect": "Allow",
        "Principal": {
          "AWS": "*"
        },
        "Action": [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientRootAccess",
          "elasticfilesystem:ClientWrite"
        ],
        "Resource": "${aws_efs_file_system.aquila_efs.arn}"
      },
      {
        "Sid": "Statement01",
        "Effect": "Deny",
        "Principal": {
          "AWS": "*"
        },
        "Action": "*",
        "Resource": "${aws_efs_file_system.aquila_efs.arn}",
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        }
      }
    ]
  }
  POLICY
}

resource "aws_efs_mount_target" "az" {
  #for_each        = data.aws_subnet_ids.current.ids
  file_system_id  = aws_efs_file_system.aquila_efs.id
  #subnet_id      = var.private_subnet_id
  subnet_id       = aws_instance.aquila.subnet_id
  security_groups = [aws_security_group.aquila_efs_sg.id]
}
