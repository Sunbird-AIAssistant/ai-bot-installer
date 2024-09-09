resource "aws_iam_role" "sbai" {
  name = "sbai"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "sbai_amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.sbai.name
}

resource "aws_eks_cluster" "sbai" {
  name     = "sbai"
  role_arn = aws_iam_role.sbai.arn
  version  = "1.30"

  vpc_config {
    subnet_ids = [
      aws_subnet.private_ap_south_1a.id,
      aws_subnet.private_ap_south_1b.id,
      aws_subnet.public_ap_south_1a.id,
      aws_subnet.public_ap_south_1b.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.sbai_amazon_eks_cluster_policy]
}
