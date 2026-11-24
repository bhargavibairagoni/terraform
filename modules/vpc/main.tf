resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Environment = var.environment
  }
}

# Internet Gateway for public traffic
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Environment = var.environment
  }
}

# Public Subnets (ALB & NAT GW)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-${var.azs[count.index]}"
    Environment = var.environment
    Type        = "Public"
  }
}

# Private App Subnets (EC2 backend, Ingestion & Validation services)
resource "aws_subnet" "private_app" {
  count             = length(var.private_app_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_app_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-app-${var.azs[count.index]}"
    Environment = var.environment
    Type        = "Private-App"
  }
}

# Private DB Subnets (RDS PostgreSQL isolated from the Internet)
resource "aws_subnet" "private_db" {
  count             = length(var.private_db_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_db_subnet_cidrs[count.index]
  availability_zone = var.azs[count.index]

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-${var.azs[count.index]}"
    Environment = var.environment
    Type        = "Private-DB"
  }
}

# Elastic IP for NAT Gateway(s)
resource "aws_eip" "nat" {
  count  = var.enable_ha_nat_gateway ? length(var.public_subnet_cidrs) : 1
  domain = "vpc"

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
  }
}

# NAT Gateway(s) for outbound Internet access from private subnets (e.g. to sync Matra/HRMS external APIs, install packages)
resource "aws_nat_gateway" "nat" {
  count         = var.enable_ha_nat_gateway ? length(var.public_subnet_cidrs) : 1
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name        = "${var.project_name}-${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.igw]
}

# Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route Tables for Private App Subnets
resource "aws_route_table" "private_app" {
  count  = var.enable_ha_nat_gateway ? length(var.private_app_subnet_cidrs) : 1
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.enable_ha_nat_gateway ? aws_nat_gateway.nat[count.index].id : aws_nat_gateway.nat[0].id
  }

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-app-rt-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_app" {
  count          = length(aws_subnet.private_app)
  subnet_id      = aws_subnet.private_app[count.index].id
  route_table_id = var.enable_ha_nat_gateway ? aws_route_table.private_app[count.index].id : aws_route_table.private_app[0].id
}

# Route Table for Private DB Subnets (Isolated - No route to 0.0.0.0/0)
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-db-rt"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_db" {
  count          = length(aws_subnet.private_db)
  subnet_id      = aws_subnet.private_db[count.index].id
  route_table_id = aws_route_table.private_db.id
}

# RDS DB Subnet Group
resource "aws_db_subnet_group" "rds" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.private_db[*].id

  tags = {
    Name        = "${var.project_name}-${var.environment}-db-subnet-group"
    Environment = var.environment
  }
}

