# eks.tf
resource "aws_eks_cluster" "eks" {
  name     = "dhananjay-magic"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.private.id]
    security_group_ids = [aws_security_group.eks_sg.id] # Attach EKS Security Group
  }
}
