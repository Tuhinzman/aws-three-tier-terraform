# Web Tier Security Group
resource "aws_security_group" "web" {
  name        = "${var.project}-${var.environment}-web-sg"
  description = "Security group for web tier"
  vpc_id      = var.vpc_id

  # HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP from Internet"
  }

  # HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS from Internet"
  }

  # SSH from specific IPs (restrict this in production)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Restrict this to admin IPs in production
    description = "SSH access (restricted)"
  }

  # Outbound: Allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-web-sg"
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Application Tier Security Group
resource "aws_security_group" "app" {
  name        = "${var.project}-${var.environment}-app-sg"
  description = "Security group for application tier"
  vpc_id      = var.vpc_id

  # Allow all traffic from web tier
  ingress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    description     = "All traffic from web tier"
  }

  # SSH from bastion host (can be replaced with a reference to bastion SG when created)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
    description     = "SSH from bastion host"
  }

  # Outbound: Allow all
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-app-sg"
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Database Tier Security Group
resource "aws_security_group" "db" {
  name        = "${var.project}-${var.environment}-db-sg"
  description = "Security group for database tier"
  vpc_id      = var.vpc_id

  # MySQL/Aurora from app tier
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
    description     = "MySQL/Aurora from app tier"
  }

  # PostgreSQL from app tier
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
    description     = "PostgreSQL from app tier"
  }

  # Outbound: Allow access back to app tier only
  egress {
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
    description     = "Return traffic to app tier"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-db-sg"
    Project     = var.project
    Environment = var.environment
    Tier        = "db"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Standby Tier Security Group
resource "aws_security_group" "standby" {
  name        = "${var.project}-${var.environment}-standby-sg"
  description = "Security group for standby tier"
  vpc_id      = var.vpc_id

  # By default, no ingress rules for standby tier
  # Rules can be added as needed when the tier is utilized

  # Allow outbound to VPC only by default
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.selected.cidr_block]
    description = "Allow outbound traffic within VPC only"
  }

  tags = {
    Name        = "${var.project}-${var.environment}-standby-sg"
    Project     = var.project
    Environment = var.environment
    Tier        = "standby"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Data source to get VPC details
data "aws_vpc" "selected" {
  id = var.vpc_id
}