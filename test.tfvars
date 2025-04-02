region             = "us-west-2"
vpc_cidr           = "10.2.0.0/16"
public_subnet_cidrs = ["10.2.1.0/24", "10.2.2.0/24"]
private_subnet_cidrs = ["10.2.3.0/24", "10.2.4.0/24"]
azs                = ["us-west-2a", "us-west-2b"]
cluster_name       = "Project-eks-test"
ami_id              = "ami-075686beab831bb7f"