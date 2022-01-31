resource "aws_iam_role" "aquila_role" {
  name = "aquila_role_${random_id.postfix.hex}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    "project" = "aquila"
  }
}

resource "aws_iam_policy" "aquila_role_policy" {
  name        = "aquila_role_policy_${random_id.postfix.hex}"
  description = "aquila policy"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Id": "certbot-dns-route53-policy",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "route53:ListHostedZones",
        "route53:GetChange",
        "ecr-public:GetAuthorizationToken",
        "ecr-public:BatchCheckLayerAvailability",
        "ecr-public:GetDownloadUrlForLayer",
        "ecr-public:GetRepositoryPolicy",
        "ecr-public:DescribeRepositories",
        "ecr-public:ListImages",
        "ecr-public:DescribeImages",
        "ecr-public:BatchGetImage",
        "ecr-public:GetLifecyclePolicy",
        "ecr-public:GetLifecyclePolicyPreview",
        "ecr-public:ListTagsForResource",
        "ecr-public:DescribeImageScanFindings",
        "sts:GetServiceBearerToken"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Effect" : "Allow",
      "Action" : [
        "route53:ChangeResourceRecordSets"
      ],
      "Resource" : [
        "arn:aws:route53:::hostedzone/${var.r53_hosted_zone_id}"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aquila-attach-policy" {
  role       = aws_iam_role.aquila_role.name
  policy_arn = aws_iam_policy.aquila_role_policy.arn
}