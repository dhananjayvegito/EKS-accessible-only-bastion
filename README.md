# EKS-accessible-only-bastion

Here’s a one-liner description of each Terraform file/component and its purpose:

provider.tf → Defines the AWS provider and region for resource deployment.

vpc.tf → Creates the VPC, which is the network boundary for the infrastructure.

subnets.tf → Defines a public subnet (for Bastion Host) and a private subnet (for DB & EKS).

internet_gateway.tf → Attaches an Internet Gateway (IGW) to the VPC for internet access.

route_table.tf → Configures routing to allow internet access for public subnet.

security_groups.tf → Defines security groups:
Bastion SG → Allows SSH (port 22) from anywhere.
DB SG → Allows MySQL access (port 3306) only from Bastion.
EKS SG → Allows API access (port 443) only from Bastion.

instances.tf → Deploys:
Bastion Host (public subnet, SSH access).
DB Instance (private subnet, restricted access).

eks.tf → Creates an EKS Cluster in the private subnet, using eks_sg security group.

iam.tf → Defines IAM role (eks_role) for EKS to interact with AWS services.
