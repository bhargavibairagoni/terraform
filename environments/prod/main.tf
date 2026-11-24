module "vpc" {
  source = "../../modules/vpc"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  azs                      = var.azs
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  enable_ha_nat_gateway    = var.enable_ha_nat_gateway
}

module "security" {
  source = "../../modules/security"

  project_name        = var.project_name
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  app_port            = var.app_port
  allowed_cidr_blocks = var.allowed_cidr_blocks
}

module "rds" {
  source = "../../modules/rds"

  project_name            = var.project_name
  environment             = var.environment
  db_instance_class       = var.db_instance_class
  allocated_storage       = var.allocated_storage
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  deletion_protection     = var.deletion_protection
  db_subnet_group_name    = module.vpc.db_subnet_group_name
  rds_security_group_id   = module.security.rds_security_group_id
}

module "compute_ec2" {
  source = "../../modules/compute_ec2"

  project_name           = var.project_name
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
  ec2_security_group_id  = module.security.ec2_app_security_group_id
  instance_profile_name  = module.security.ec2_instance_profile_name
  instance_type          = var.instance_type
  min_size               = var.min_size
  max_size               = var.max_size
  desired_capacity       = var.desired_capacity
  app_port               = var.app_port
}

module "frontend_cdn" {
  source = "../../modules/frontend_s3_cdn"

  project_name = var.project_name
  environment  = var.environment
  alb_dns_name = module.compute_ec2.alb_dns_name
}

