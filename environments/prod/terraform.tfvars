aws_region   = "ap-south-1"
project_name = "britannia-compliance"
environment  = "prod"

# Network
vpc_cidr                 = "10.30.0.0/16"
azs                      = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs      = ["10.30.1.0/24", "10.30.2.0/24"]
private_app_subnet_cidrs = ["10.30.11.0/24", "10.30.12.0/24"]
private_db_subnet_cidrs  = ["10.30.21.0/24", "10.30.22.0/24"]
enable_ha_nat_gateway    = true # High availability: 1 NAT Gateway per AZ in Production

# Application
app_port            = 8080
allowed_cidr_blocks = ["0.0.0.0/0"]

# EC2 Compute (Production Multi-AZ ASG)
instance_type    = "t3.medium" # Can scale to t3.large or c6i.large for heavy batch runs
min_size         = 2
max_size         = 4
desired_capacity = 2

# Database (Production Multi-AZ with automated backups and deletion protection)
db_instance_class       = "db.t4g.medium"
allocated_storage       = 50
multi_az                = true
backup_retention_period = 30
deletion_protection     = true

