variable "eks_role_name" {
  description = "Name of the IAM role for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" { type = list(string) }

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}
variable "vpc_id" { type = string }
variable "key_name" { type = string }
variable "vpc_cidr" { type = string }