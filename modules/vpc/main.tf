# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project}-${var.environment}-vpc"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Create Web (Public) Subnets
resource "aws_subnet" "web" {
  count                   = length(var.web_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.web_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project}-${var.environment}-web-subnet-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Create App (Private) Subnets
resource "aws_subnet" "app" {
  count                   = length(var.app_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-app-subnet-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Create DB (Private) Subnets
resource "aws_subnet" "db" {
  count                   = length(var.db_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-db-subnet-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "db"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Create Standby (Private) Subnets
resource "aws_subnet" "standby" {
  count                   = length(var.standby_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.standby_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project}-${var.environment}-standby-subnet-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "standby"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  count  = length(var.web_subnet_cidrs)
  domain = "vpc"

  tags = {
    Name        = "${var.project}-${var.environment}-eip-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  count         = length(var.web_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.web[count.index].id

  tags = {
    Name        = "${var.project}-${var.environment}-nat-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }

  depends_on = [aws_internet_gateway.igw]
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-public-rt"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# App Tier Route Tables (One per AZ for NAT Gateway)
resource "aws_route_table" "app" {
  count  = length(var.app_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }

  tags = {
    Name        = "${var.project}-${var.environment}-app-rt-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# DB Tier Route Tables (No internet access)
resource "aws_route_table" "db" {
  count  = length(var.db_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-db-rt-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "db"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Standby Tier Route Tables (No internet access by default)
resource "aws_route_table" "standby" {
  count  = length(var.standby_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project}-${var.environment}-standby-rt-${count.index + 1}"
    Project     = var.project
    Environment = var.environment
    Tier        = "standby"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

# Route Table Associations
resource "aws_route_table_association" "web" {
  count          = length(var.web_subnet_cidrs)
  subnet_id      = aws_subnet.web[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "app" {
  count          = length(var.app_subnet_cidrs)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app[count.index].id
}

resource "aws_route_table_association" "db" {
  count          = length(var.db_subnet_cidrs)
  subnet_id      = aws_subnet.db[count.index].id
  route_table_id = aws_route_table.db[count.index].id
}

resource "aws_route_table_association" "standby" {
  count          = length(var.standby_subnet_cidrs)
  subnet_id      = aws_subnet.standby[count.index].id
  route_table_id = aws_route_table.standby[count.index].id
}

# Network ACLs for each tier
resource "aws_network_acl" "web" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.web[*].id

  # Allow HTTP from anywhere
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  # Allow HTTPS from anywhere
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  # Allow SSH (optional, for administration)
  ingress {
    protocol   = "tcp"
    rule_no    = 120
    action     = "allow"
    cidr_block = "0.0.0.0/0" # In production, restrict to admin IPs
    from_port  = 22
    to_port    = 22
  }

  # Allow ephemeral ports for return traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 130
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.project}-${var.environment}-web-nacl"
    Project     = var.project
    Environment = var.environment
    Tier        = "web"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

resource "aws_network_acl" "app" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.app[*].id

  # Allow traffic from web tier
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  # Allow return traffic
  ingress {
    protocol   = "tcp"
    rule_no    = 110
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  # Allow all outbound traffic
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.project}-${var.environment}-app-nacl"
    Project     = var.project
    Environment = var.environment
    Tier        = "app"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

resource "aws_network_acl" "db" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.db[*].id

  # Allow traffic only from app tier
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 65535
  }

  # Allow all outbound to VPC only
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.project}-${var.environment}-db-nacl"
    Project     = var.project
    Environment = var.environment
    Tier        = "db"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}

resource "aws_network_acl" "standby" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = aws_subnet.standby[*].id

  # Allow traffic from within VPC
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow outbound to VPC only
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.project}-${var.environment}-standby-nacl"
    Project     = var.project
    Environment = var.environment
    Tier        = "standby"
    ManagedBy   = "terraform"
    Owner       = var.owner
  }
}