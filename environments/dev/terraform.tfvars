aws_region   = "ap-south-1"
project_name = "britannia-compliance"
environment  = "dev"

# Network
vpc_cidr                 = "10.10.0.0/16"
azs                      = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs      = ["10.10.1.0/24", "10.10.2.0/24"]
private_app_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]
private_db_subnet_cidrs  = ["10.10.21.0/24", "10.10.22.0/24"]
enable_ha_nat_gateway    = false # Cost saving: 1 single NAT Gateway for DEV

# Application
app_port            = 8080
allowed_cidr_blocks = ["0.0.0.0/0"] # Can be restricted to Britannia office/VPN CIDR

# EC2 Compute (Sized for DEV testing)
instance_type    = "t3.small"
min_size         = 1
max_size         = 1
desired_capacity = 1

# Database (Sized for DEV)
db_instance_class       = "db.t4g.micro"
allocated_storage       = 20
multi_az                = false
backup_retention_period = 1
deletion_protection     = false

