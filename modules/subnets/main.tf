data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}

locals {
  az_a = data.aws_availability_zones.available.names[0]
  az_b = data.aws_availability_zones.available.names[1]
  az_c = data.aws_availability_zones.available.names[2]
}

# Reserved Subnets
resource "aws_subnet" "reserved_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.0.0/20"
  availability_zone       = local.az_a
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 0)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-reserved-A"
  }
}

resource "aws_subnet" "reserved_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.64.0/20"
  availability_zone       = local.az_b
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 4)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-reserved-B"
  }
}

resource "aws_subnet" "reserved_c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.128.0/20"
  availability_zone       = local.az_c
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 8)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-reserved-C"
  }
}

# DB Subnets
resource "aws_subnet" "db_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.16.0/20"
  availability_zone       = local.az_a
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 1)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-db-A"
  }
}

resource "aws_subnet" "db_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.80.0/20"
  availability_zone       = local.az_b
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 5)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-db-B"
  }
}

resource "aws_subnet" "db_c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.144.0/20"
  availability_zone       = local.az_c
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 9)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-db-C"
  }
}

# App Subnets
resource "aws_subnet" "app_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.32.0/20"
  availability_zone       = local.az_a
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 2)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-app-A"
  }
}

resource "aws_subnet" "app_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.96.0/20"
  availability_zone       = local.az_b
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 6)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-app-B"
  }
}

resource "aws_subnet" "app_c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.160.0/20"
  availability_zone       = local.az_c
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 10)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-app-C"
  }
}

# Web Subnets
resource "aws_subnet" "web_a" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.48.0/20"
  availability_zone       = local.az_a
  map_public_ip_on_launch = true
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 3)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-web-A"
  }
}

resource "aws_subnet" "web_b" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.112.0/20"
  availability_zone       = local.az_b
  map_public_ip_on_launch = true
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 7)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-web-B"
  }
}

resource "aws_subnet" "web_c" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.16.176.0/20"
  availability_zone       = local.az_c
  map_public_ip_on_launch = true
  ipv6_cidr_block         = cidrsubnet(data.aws_vpc.selected.ipv6_cidr_block, 8, 11)
  assign_ipv6_address_on_creation = true

  tags = {
    Name = "sn-web-C"
  }
}