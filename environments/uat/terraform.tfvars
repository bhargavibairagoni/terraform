aws_region   = "ap-south-1"
project_name = "britannia-compliance"
environment  = "uat"

# Network
vpc_cidr                 = "10.20.0.0/16"
azs                      = ["ap-south-1a", "ap-south-1b"]
public_subnet_cidrs      = ["10.20.1.0/24", "10.20.2.0/24"]
private_app_subnet_cidrs = ["10.20.11.0/24", "10.20.12.0/24"]
private_db_subnet_cidrs  = ["10.20.21.0/24", "10.20.22.0/24"]
enable_ha_nat_gateway    = false

# Application
app_port            = 8080
allowed_cidr_blocks = ["0.0.0.0/0"]

# EC2 Compute (UAT Testing)
instance_type    = "t3.medium"
min_size         = 1
max_size         = 2
desired_capacity = 1

# Database (UAT)
db_instance_class       = "db.t4g.small"
allocated_storage       = 30
multi_az                = false
backup_retention_period = 7
deletion_protection     = false

