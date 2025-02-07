# EKS-accessible-only-bastion

1. provider.tf → AWS Provider Configuration

Purpose:
Specifies AWS as the cloud provider where all resources will be created.
Defines the region (us-east-1) where the infrastructure is deployed.

2. vpc.tf → Virtual Private Cloud (VPC)
Purpose:
Creates an isolated network within AWS for hosting resources.
Defines the CIDR block (10.0.0.0/16), which represents the network range.
Enables DNS support for resolving hostnames within the VPC.

📌 Why do we need a VPC?
To segregate resources into private and public subnets.
To ensure security and controlled communication between components.

3. subnets.tf → Public & Private Subnets
Purpose:
Public Subnet (10.0.1.0/24) → Hosts the Bastion Host (which has internet access).
Private Subnet (10.0.2.0/24) → Hosts the DB instance & EKS cluster (which should not be publicly accessible).

📌 Why do we need subnets?
Public subnet allows external access to the Bastion Host.
Private subnet isolates sensitive resources from the internet.

4. internet_gateway.tf → Internet Gateway (IGW)
Purpose:
Enables public internet access for resources in the public subnet (Bastion Host).
Required to allow the Bastion Host to SSH into private instances.

📌 Why do we need an Internet Gateway?
Without it, public instances cannot connect to the internet for updates or remote access.

5. route_table.tf → Routing Configuration
Purpose:
Defines how network traffic flows between public/private resources.
Public Route Table allows outbound traffic from the public subnet to the internet.

📌 Why do we need a Route Table?
Ensures proper communication between subnets, IGW, and external resources.
6. security_groups.tf → Security Groups (Firewall Rules)
6.1. bastion_sg (Bastion Host Security Group)
Allows SSH (port 22) access from anywhere (0.0.0.0/0).
Enables outbound traffic to the DB instance.
6.2. db_sg (Database Security Group)
Allows MySQL access (port 3306) only from Bastion Host.
Restricts direct access from the internet.
6.3. eks_sg (EKS Cluster Security Group)
Allows API server communication (port 443) only from Bastion Host.

📌 Why do we need Security Groups?
Ensures strict network access control between resources.
Prevents unauthorized access to the database & Kubernetes API.

7. instances.tf → Compute Instances (EC2)
7.1. bastion (Bastion Host in Public Subnet)
Purpose:
Acts as a jump server to access resources in the private subnet.
Has a public IP and SSH access for secure administration.

7.2. db (Database Instance in Private Subnet)

Purpose:
Stores application data securely.
Does not have a public IP, so it cannot be accessed directly from the internet.

📌 Why do we need a Bastion Host?
Without it, there is no way to SSH into private resources like the DB instance.

8. eks.tf → EKS Cluster Setup
Purpose:
Deploys an Amazon Elastic Kubernetes Service (EKS) Cluster in the private subnet.
Uses IAM role (eks_role) for AWS services interaction.
Uses EKS security group (eks_sg) to restrict API access.

📌 Why do we need an EKS cluster?
To run containerized workloads in Kubernetes.
Provides auto-scaling and self-healing for applications.

9. iam.tf → IAM Role for EKS
Purpose:
Creates an IAM role (eks_role) with permissions for EKS to manage AWS resources.

📌 Why do we need IAM roles?
EKS needs permissions to provision networking & worker nodes.

Final Thoughts 💡
This setup ensures security, scalability, and automation by:
✅ Keeping EKS & DB in a private subnet (security-first approach).
✅ Using a Bastion Host to securely access private instances.
✅ Defining security groups to restrict access between components.
