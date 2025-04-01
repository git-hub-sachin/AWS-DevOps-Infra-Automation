region             = "us-west-1"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs                = ["us-west-1a", "us-west-1b"]
key_name           = "EMA-EKS-dev"
cluster_name       = "Project-eks-dev"
ami_id              = "ami-04f7a54071e74f488"