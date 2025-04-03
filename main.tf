terraform {
  backend "s3" {
    bucket         = "my-terraform-state-docker-image"
    # key            = "terraform.tfstate"            
    region         = "us-west-1"                        
    # dynamodb_table = "terraform-locks"                 
  }
}

resource "tls_private_key" "generated_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.cluster_name}-key"
  public_key = tls_private_key.generated_key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.generated_key.private_key_pem
  filename = "${var.cluster_name}-key.pem"
  file_permission = "0600"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                = var.azs
}

module "bastion" {
  source          = "./modules/bastion"
  ami_id          = var.ami_id
  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
  key_name        = aws_key_pair.key_pair.key_name
}

module "elasticsearch" {
  source           = "./modules/elasticsearch"
  ami_id          = var.ami_id
  vpc_id           = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr         = var.vpc_cidr
  key_name        = aws_key_pair.key_pair.key_name
}

module "mongodb" {
  source           = "./modules/mongodb"
  ami_id          = var.ami_id
  vpc_id           = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr         = var.vpc_cidr
  key_name        = aws_key_pair.key_pair.key_name
}

module "eks" {
  source             = "./modules/eks"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id    
  key_name        = aws_key_pair.key_pair.key_name       
  vpc_cidr           = var.vpc_cidr                
  cluster_name       = var.cluster_name
  eks_role_name      = "${var.cluster_name}-eks-role"
}