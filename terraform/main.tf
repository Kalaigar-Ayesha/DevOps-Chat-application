module "vpc" {
  source = "./modules/vpc"

  name_prefix         = var.name_prefix
  vpc_cidr            = var.vpc_cidr
  azs                 = var.azs
  public_subnet_cidrs = var.public_subnet_cidrs
  app_subnet_cidrs    = var.app_subnet_cidrs
  db_subnet_cidrs     = var.db_subnet_cidrs
}

module "app" {
  source = "./modules/app_tier"

  name_prefix      = var.name_prefix
  vpc_id           = module.vpc.vpc_id
  vpc_cidr         = var.vpc_cidr
  app_subnet_ids   = module.vpc.app_subnet_ids
  instance_type    = var.instance_type_app
  key_name         = var.ec2_key_name
  ssh_ingress_cidr = var.ssh_ingress_cidr

  backend_image  = var.backend_image
  jwt_secret     = var.jwt_secret
  cloudinary_url = var.cloudinary_url

  # DB connectivity is wired after docdb is created; terraform handles ordering
  docdb_endpoint = module.docdb.endpoint
  docdb_username = var.docdb_master_username
  docdb_password = var.docdb_master_password
  docdb_db_name  = "chatapp"
}

module "docdb" {
  source = "./modules/docdb"

  name_prefix   = var.name_prefix
  vpc_id        = module.vpc.vpc_id
  db_subnet_ids = module.vpc.db_subnet_ids

  master_username = var.docdb_master_username
  master_password = var.docdb_master_password
  instance_class  = var.docdb_instance_class
}

resource "aws_security_group_rule" "app_to_docdb" {
  type                     = "ingress"
  description              = "MongoDB from app tier"
  from_port                = 27017
  to_port                  = 27017
  protocol                 = "tcp"
  security_group_id        = module.docdb.security_group_id
  source_security_group_id = module.app.app_sg_id
}

module "web" {
  source = "./modules/web_tier"

  name_prefix       = var.name_prefix
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  instance_type     = var.instance_type_web
  key_name          = var.ec2_key_name
  ssh_ingress_cidr  = var.ssh_ingress_cidr

  frontend_image   = var.frontend_image
  app_alb_dns_name = module.app.alb_dns_name
}

module "secrets_manager" {
  source = "./modules/secrets_manager"

  name_prefix    = var.name_prefix
  jwt_secret     = var.jwt_secret
  cloudinary_url = var.cloudinary_url
}

module "eks" {
  source = "./modules/eks"

  name_prefix             = var.name_prefix
  cluster_name            = "${var.name_prefix}-eks-cluster"
  vpc_id                  = module.vpc.vpc_id
  public_subnet_ids       = module.vpc.public_subnet_ids
  private_subnet_ids      = module.vpc.app_subnet_ids
  node_instance_type      = var.eks_node_instance_type
  desired_node_count      = var.eks_desired_node_count
  min_node_count          = var.eks_min_node_count
  max_node_count          = var.eks_max_node_count
  docdb_security_group_id = module.docdb.security_group_id
}

module "acm" {
  source = "./modules/acm"

  name_prefix = var.name_prefix
}




