# security_groups.tf
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id
  ingress { from_port = 22 to_port = 22 protocol = "tcp" cidr_blocks = ["0.0.0.0/0"] }
  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "bastion-sg" }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id
  ingress { from_port = 3306 to_port = 3306 protocol = "tcp" security_groups = [aws_security_group.bastion_sg.id] }
  egress { from_port = 0 to_port = 0 protocol = "-1" cidr_blocks = ["0.0.0.0/0"] }
  tags = { Name = "db-sg" }
}

resource "aws_security_group" "eks_sg" {
  vpc_id = aws_vpc.main.id
  
  # Allow inbound access to EKS API server only from Bastion Host
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Restrict access to Bastion
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = { Name = "eks-sg" }
}

# instances.tf
resource "aws_instance" "bastion" {
  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type          = "t2.micro"
  subnet_id             = aws_subnet.public.id
  security_groups       = [aws_security_group.bastion_sg.name]
  associate_public_ip_address = true
  tags = { Name = "Bastion Host" }
}

resource "aws_instance" "db" {
  ami                    = "ami-0c55b159cbfafe1f0"
  instance_type          = "t2.micro"
  subnet_id             = aws_subnet.private.id
  security_groups       = [aws_security_group.db_sg.name]
  tags = { Name = "DB Instance" }
}
