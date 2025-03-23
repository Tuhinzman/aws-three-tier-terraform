# AWS Three-Tier Architecture with Standby Tier

This repository contains Terraform configurations to deploy a highly available three-tier architecture in AWS with an additional standby tier for future expansion and disaster recovery.

## Architecture Diagram

```
                                  AWS Cloud (Region)
+-----------------------------------------------------------------------------------------------+
|                                                                                               |
|  +-------------------------------+   +-------------------------------+   +------------------+ |
|  |        Availability Zone A    |   |        Availability Zone B    |   |  Availability Zone C |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  | |   Public Subnet (Web)     | |   | |   Public Subnet (Web)     | |   | |  Public Subnet | |
|  | |   10.0.48.0/20            | |   | |   10.0.112.0/20           | |   | |  10.0.176.0/20 | |
|  | | +-----+   +-----+  +----+ | |   | | +-----+   +-----+  +----+ | |   | | +---+ +---+ +--+ |
|  | | | IGW |<->| NATG |<-|EC2 | | |   | | | IGW |<->| NATG |<-|EC2 | | |   | | |IGW|<|NAT|<|EC2|
|  | | +-----+   +-----+  +----+ | |   | | +-----+   +-----+  +----+ | |   | | +---+ +---+ +--+ |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  |              ^                |   |              ^                |   |         ^          |
|  |              | SG Rules       |   |              | SG Rules       |   |         | SG Rules |
|  |              v                |   |              v                |   |         v          |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  | |   Private Subnet (App)    | |   | |   Private Subnet (App)    | |   | | Private Subnet | |
|  | |   10.0.32.0/20            | |   | |   10.0.96.0/20            | |   | | 10.0.160.0/20  | |
|  | | +-----------------------+ | |   | | +-----------------------+ | |   | | +------------+ | |
|  | | |         EC2           | | |   | | |         EC2           | | |   | | |     EC2    | | |
|  | | +-----------------------+ | |   | | +-----------------------+ | |   | | +------------+ | |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  |              ^                |   |              ^                |   |         ^          |
|  |              | SG Rules       |   |              | SG Rules       |   |         | SG Rules |
|  |              v                |   |              v                |   |         v          |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  | |   Private Subnet (DB)     | |   | |   Private Subnet (DB)     | |   | | Private Subnet | |
|  | |   10.0.16.0/20            | |   | |   10.0.80.0/20            | |   | | 10.0.144.0/20  | |
|  | | +-----------------------+ | |   | | +-----------------------+ | |   | | +------------+ | |
|  | | |       RDS/Aurora      | | |   | | |       RDS/Aurora      | | |   | | |  RDS/Aurora | | |
|  | | +-----------------------+ | |   | | +-----------------------+ | |   | | +------------+ | |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  |              ^                |   |              ^                |   |         ^          |
|  |              | SG Rules       |   |              | SG Rules       |   |         | SG Rules |
|  |              v                |   |              v                |   |         v          |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  | |   Private Subnet (Standby)| |   | |   Private Subnet (Standby)| |   | | Private Subnet | |
|  | |   10.0.0.0/20             | |   | |   10.0.64.0/20            | |   | | 10.0.128.0/20  | |
|  | | +-----------------------+ | |   | | +-----------------------+ | |   | | +------------+ | |
|  | | |     Future Use        | | |   | | |     Future Use        | | |   | | |  Future Use | | |
|  | | +-----------------------+ | |   | | +-----------------------+ | |   | | +------------+ | |
|  | +---------------------------+ |   | +---------------------------+ |   | +----------------+ |
|  +-------------------------------+   +-------------------------------+   +------------------+ |
|                                                                                               |
+-----------------------------------------------------------------------------------------------+
```

## Tier Explanations

### 1. Web Tier (Public Subnets)
- **Purpose**: Hosts web servers, load balancers, and other public-facing resources
- **Security Boundaries**: 
  - Allows inbound HTTP/HTTPS traffic from the internet
  - Restricts outbound traffic to necessary services
  - Protected by security groups and NACLs
  - Resources have public IPs or are behind load balancers

### 2. Application Tier (Private Subnets)
- **Purpose**: Hosts application servers and business logic components
- **Security Boundaries**:
  - No direct internet access
  - Accepts traffic only from the web tier
  - Outbound internet access via NAT gateways
  - Resources are isolated from direct external access

### 3. Database Tier (Private Subnets)
- **Purpose**: Hosts databases and data persistence layers
- **Security Boundaries**:
  - Highly restricted access (only from application tier)
  - No internet access (inbound or outbound)
  - Encrypted storage and transit
  - Multiple availability zones for high availability

### 4. Standby Tier (Private Subnets)
- **Purpose**: Reserved for future expansion, disaster recovery, or specialized workloads
- **Security Boundaries**:
  - Isolated from production traffic
  - Configurable connectivity based on future needs
  - Separate subnet enables clear security policies

## Benefits of Standby Tier

The standby tier provides numerous advantages to the architecture:

1. **Future Expansion**:
   - Pre-allocated address space for new services
   - Enables clean separation of new components
   - Reduces the need for network redesign as applications grow

2. **Disaster Recovery**:
   - Dedicated space for DR components
   - Can host replicas, backups, or recovery infrastructure
   - Enables separate security controls for recovery mechanisms

3. **Specialized Workloads**:
   - Ideal for batch processing jobs
   - Can accommodate data analytics platforms
   - Provides space for one-off or periodic processing needs

4. **Flexibility**:
   - Accommodates unexpected future requirements
   - Provides isolation for testing new services
   - Creates clear separation for compliance-related needs

5. **Reduced Risk**:
   - Changes in standby tier minimize impact to production
   - Enables gradual transition of workloads
   - Provides clean separation for staged deployments

## Deployment Instructions

### Prerequisites
- AWS CLI configured with appropriate permissions
- Terraform (v1.0.0 or higher) installed
- S3 bucket for Terraform state (optional but recommended)

### Deployment Steps

1. **Initialize the project**:
   ```bash
   terraform init
   ```

2. **Customize variables** (optional):
   Edit `terraform.tfvars` to customize deployment parameters.

3. **Preview the deployment**:
   ```bash
   terraform plan
   ```

4. **Deploy the infrastructure**:
   ```bash
   terraform apply
   ```

5. **Verify the deployment**:
   Check the AWS Console to verify all resources were created correctly.

6. **Cleanup** (when no longer needed):
   ```bash
   terraform destroy
   ```

## Resource Naming Conventions

Resources follow a standardized naming convention:
```
[project]-[environment]-[tier]-[resource_type]-[optional_identifier]
```

Examples:
- VPC: `three-tier-dev-vpc`
- Web Subnet: `three-tier-dev-web-subnet-az1`
- App Security Group: `three-tier-dev-app-sg`

## Tagging Strategy

All resources are tagged with:
- `Project`: three-tier-architecture
- `Environment`: dev
- `Tier`: web/app/db/standby (as appropriate)
- `ManagedBy`: terraform
- `Owner`: devops

Additional resource-specific tags are applied where appropriate.

## Security Considerations

1. **Network Segmentation**:
   - Each tier is isolated in its own subnet
   - Traffic flow is controlled via security groups and NACLs
   - Principle of least privilege applied throughout

2. **Access Controls**:
   - IAM roles with minimal required permissions
   - Bastion host for secure administrative access
   - No direct internet access to private resources

3. **Data Protection**:
   - Encryption at rest for all storage
   - Encryption in transit for all communication
   - Regular automated snapshots for data recovery

4. **Monitoring and Logging**:
   - CloudWatch logging enabled for all services
   - CloudTrail for API activity monitoring
   - VPC Flow Logs for network traffic analysis

5. **Compliance Best Practices**:
   - Resource documentation via tagging
   - Standardized security group policies
   - Automated security scanning