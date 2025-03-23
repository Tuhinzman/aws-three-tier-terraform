# Animals4Life VPC Infrastructure with Terraform

This repository contains Terraform code that creates a complete AWS networking infrastructure based on the Animals4Life VPC template. It's designed following AWS best practices with a multi-AZ, multi-tier architecture.

## Architecture Overview

This infrastructure creates a VPC with public and private subnets distributed across three availability zones, following a tiered approach:

```
┌──────────────────────────────────────────────────────────────┐
│                        VPC (10.16.0.0/16)                     │
│                                                              │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐       │
│  │    AZ-A     │    │    AZ-B     │    │    AZ-C     │       │
│  │             │    │             │    │             │       │
│  │ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │       │
│  │ │ Reserved│ │    │ │ Reserved│ │    │ │ Reserved│ │       │
│  │ │10.16.0/20│ │    │ │10.16.64/20│    │ │10.16.128/20     │
│  │ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │       │
│  │             │    │             │    │             │       │
│  │ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │       │
│  │ │   DB    │ │    │ │   DB    │ │    │ │   DB    │ │       │
│  │ │10.16.16/20│    │ │10.16.80/20│    │ │10.16.144/20     │
│  │ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │       │
│  │             │    │             │    │             │       │
│  │ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │       │
│  │ │   App   │ │    │ │   App   │ │    │ │   App   │ │       │
│  │ │10.16.32/20│    │ │10.16.96/20│    │ │10.16.160/20     │
│  │ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │       │
│  │             │    │             │    │             │       │
│  │ ┌─────────┐ │    │ ┌─────────┐ │    │ ┌─────────┐ │       │
│  │ │   Web   │ │    │ │   Web   │ │    │ │   Web   │ │       │
│  │ │10.16.48/20│    │ │10.16.112/20   │ │10.16.176/20     │
│  │ └─────────┘ │    │ └─────────┘ │    │ └─────────┘ │       │
│  └──────┬──────┘    └──────┬──────┘    └─────────────┘       │
│         │                  │                                  │
│   ┌─────┴─────┐      ┌─────┴─────┐                           │
│   │EC2 Instance│      │EC2 Instance│                          │
│   │     A      │      │     B      │                          │
│   └─────┬─────┘      └─────┬─────┘                           │
│         │                  │                                  │
│         └──────────┬───────┘                                  │
│                    │                                          │
│             ┌──────┴──────┐                                   │
│             │ Internet    │                                   │
│             │  Gateway    │                                   │
│             └─────────────┘                                   │
└──────────────────────────────────────────────────────────────┘
```

## Resources Created

The Terraform code creates the following AWS resources:

1. **VPC**: A Virtual Private Cloud (10.16.0.0/16) with both IPv4 and IPv6 CIDR blocks
   - Dual-stack IPv4/IPv6 support
   - DNS hostnames and DNS support enabled

2. **Subnets**: 12 subnets (4 tiers across 3 availability zones)
   - **Reserved Tier** (private):
     - AZ-A: 10.16.0.0/20 + IPv6 (:00::/64)
     - AZ-B: 10.16.64.0/20 + IPv6 (:04::/64)
     - AZ-C: 10.16.128.0/20 + IPv6 (:08::/64)
   - **Database Tier** (private):
     - AZ-A: 10.16.16.0/20 + IPv6 (:01::/64)
     - AZ-B: 10.16.80.0/20 + IPv6 (:05::/64)
     - AZ-C: 10.16.144.0/20 + IPv6 (:09::/64)
   - **Application Tier** (private):
     - AZ-A: 10.16.32.0/20 + IPv6 (:02::/64)
     - AZ-B: 10.16.96.0/20 + IPv6 (:06::/64)
     - AZ-C: 10.16.160.0/20 + IPv6 (:0A::/64)
   - **Web Tier** (public):
     - AZ-A: 10.16.48.0/20 + IPv6 (:03::/64)
     - AZ-B: 10.16.112.0/20 + IPv6 (:07::/64)
     - AZ-C: 10.16.176.0/20 + IPv6 (:0B::/64)

3. **Internet Gateway**: Allows resources in public subnets to connect to the internet

4. **Route Tables**:
   - Web tier route table with default routes to the Internet Gateway for both IPv4 (0.0.0.0/0) and IPv6 (::/0)
   - Associations between route tables and appropriate subnets

5. **Security Groups**:
   - Instance security group allowing:
     - SSH access (port 22) from any IPv4 and IPv6 address
     - HTTP access (port 80) from any IPv4 address
     - All outbound traffic

6. **IAM Resources**:
   - IAM role for EC2 Session Manager with appropriate permissions
   - IAM instance profile for attaching the role to EC2 instances
   - Policies allowing SSM, SSM Messages, and EC2 Messages actions

7. **EC2 Instances**:
   - Two t2.micro instances running Amazon Linux 2
   - Placed in different web subnets (AZ-A and AZ-B) for high availability
   - Configured with user data to install and run a web server
   - Public IP addresses and internet access
   - Session Manager access for management without SSH keys

## Module Structure

The code is organized into the following Terraform modules:

```
aws-three-tier-terraform/
├── main.tf                     # Main configuration file that calls all modules
├── variables.tf                # Input variables for the root module
├── outputs.tf                  # Output values from the root module
├── versions.tf                 # Terraform and provider version constraints
├── terraform.tfvars           # Variable values for customization
├── README.md                   # Project documentation (this file)
│
└── modules/                    # Subdirectory containing all modules
    ├── vpc/                    # VPC module
    │   ├── main.tf             # VPC resource definition with IPv6 support
    │   ├── variables.tf        # VPC module input variables
    │   └── outputs.tf          # VPC module outputs
    │
    ├── subnets/                # Subnets module
    │   ├── main.tf             # 12 subnet definitions across 3 AZs
    │   ├── variables.tf        # Subnet module input variables
    │   └── outputs.tf          # Subnet module outputs
    │
    ├── internet_gateway/       # Internet Gateway module
    │   ├── main.tf             # Internet Gateway resource definition
    │   ├── variables.tf        # IGW module input variables
    │   └── outputs.tf          # IGW module outputs
    │
    ├── route_tables/           # Route Tables module
    │   ├── main.tf             # Route table definitions and associations
    │   ├── variables.tf        # Route table module input variables
    │   └── outputs.tf          # Route table module outputs
    │
    ├── security_groups/        # Security Groups module
    │   ├── main.tf             # Security group rules for EC2 instances
    │   ├── variables.tf        # Security group module input variables
    │   └── outputs.tf          # Security group module outputs
    │
    ├── iam/                    # IAM module
    │   ├── main.tf             # IAM roles and policies for Session Manager
    │   └── outputs.tf          # IAM module outputs
    │
    └── ec2/                    # EC2 module
        ├── main.tf             # EC2 instance definitions with user data
        ├── variables.tf        # EC2 module input variables
        └── outputs.tf          # EC2 module outputs
```

Each module handles a specific component of the infrastructure:

- **vpc**: Creates the VPC with DNS support and IPv6 CIDR block
- **subnets**: Creates all 12 subnets (4 tiers × 3 AZs) with the appropriate CIDR blocks
- **internet_gateway**: Creates and attaches the internet gateway to the VPC
- **route_tables**: Creates route tables with routes to the internet and associates them with subnets
- **security_groups**: Creates security groups with rules for SSH and HTTP access
- **iam**: Creates IAM roles and policies for EC2 Session Manager access
- **ec2**: Creates the EC2 instances with user data for web server setup

## Usage

### Prerequisites

- Terraform v1.0.0 or newer
- AWS CLI configured with appropriate credentials
- AWS account with permissions to create the resources

### Deployment Steps

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/a4l-vpc-terraform.git
   cd a4l-vpc-terraform
   ```

2. Modify the `terraform.tfvars` file with your desired values:
   ```hcl
   region         = "us-east-1"
   vpc_cidr_block = "10.16.0.0/16"
   vpc_name       = "a4l-vpc1"
   instance_type  = "t2.micro"
   # ami_id = "" # Leave empty to use latest Amazon Linux 2 AMI
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the changes:
   ```bash
   terraform apply
   ```

6. To destroy the infrastructure when done:
   ```bash
   terraform destroy
   ```

## Notes for AWS SAA-03 Exam Preparation

This infrastructure demonstrates several important concepts relevant to the AWS Solutions Architect Associate exam:

1. **VPC Design**: Shows a proper multi-tier, multi-AZ VPC architecture with public and private subnets
2. **CIDR Allocation**: Demonstrates proper CIDR block allocation and subnet sizing
3. **IPv6 Support**: Implements dual-stack IPv4/IPv6 networking
4. **Route Tables**: Shows how to route traffic for different subnet tiers
5. **Security Groups**: Demonstrates how to secure EC2 instances with appropriate security groups
6. **IAM Roles**: Uses IAM roles for secure EC2 instance management via Session Manager
7. **User Data**: Shows how to bootstrap an EC2 instance with user data

Key exam areas covered:
- VPC Architecture and Design
- Public and Private Subnets
- Internet Gateway Configuration
- Security Group Implementation
- IAM Roles and Instance Profiles
- EC2 Instance Deployment and Configuration

## Important Considerations

- This template creates a t2.micro EC2 instance which falls under the AWS Free Tier
- Remember to run `terraform destroy` when you're done to avoid unnecessary charges
- The VPC CIDR 10.16.0.0/16 provides up to 65,536 IP addresses
- Each subnet has a /20 CIDR block providing 4,096 IP addresses per subnet
- Two EC2 instances are placed in different public subnets (AZ-A and AZ-B) with public IPs for internet access and high availability
- Session Manager is configured for secure instance access without SSH key pairs

## Additional Resources for Exam Preparation

1. Study the VPC architecture diagram to understand subnet layout and CIDR allocation
2. Review the route table configuration to understand traffic flow
3. Examine the security group rules to understand network security implementation
4. Consider how you might extend this architecture with:
   - NAT Gateways for private subnet internet access
   - VPC Endpoints for AWS service access
   - Transit Gateways for multi-VPC connectivity
   - Load balancers for high availability