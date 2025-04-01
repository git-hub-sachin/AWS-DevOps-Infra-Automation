variable "vpc_cidr" {}
variable "public_subnet_cidrs" {}
variable "private_subnet_cidrs" {}
variable "azs" {}
variable "key_name"{}
variable "cluster_name" {}
variable "region" {
  description = "AWS region"
  type        = string
}
variable "ami_id" {
  description = "AMI ID for the bastion instance"
  type        = string
}