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

1. **VPC**: A Virtual Private Cloud with IPv4 and IPv6 CIDR blocks
2. **Subnets**: 12 subnets (4 tiers across 3 availability zones)
   - Web tier (public)
   - App tier (private)
   - DB tier (private)
   - Reserved tier (private)
3. **Internet Gateway**: For internet access from public subnets
4. **Route Tables**: Route tables for subnet tiers with appropriate routes
5. **Security Groups**: A security group for the EC2 instances
6. **IAM Roles**: Session Manager role for EC2 instance management
7. **EC2 Instances**: Two public web instances in different web subnets with internet access

## Module Structure

The code is organized into the following Terraform modules:

- **vpc**: Creates the VPC and associated IPv6 CIDR block
- **subnets**: Creates all 12 subnets across 3 availability zones
- **internet_gateway**: Creates and attaches the internet gateway
- **route_tables**: Creates route tables and associates them with subnets
- **security_groups**: Creates security groups for resources
- **iam**: Creates IAM roles and instance profiles
- **ec2**: Creates the EC2 instance with user data

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