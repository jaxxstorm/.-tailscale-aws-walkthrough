# Local variables for VPC configuration
locals {
  # Define the main VPC CIDR block
  vpc_cidr = "172.16.0.0/16"

  # Create 6 subnets from the main VPC CIDR, each with a /19 prefix
  vpc_subnets = cidrsubnets(local.vpc_cidr, 3, 3, 3, 3, 3, 3)

  # Allocate the first 3 subnets for private use
  vpc_private_subnets = slice(local.vpc_subnets, 0, 3)
  
  # Allocate the last 3 subnets for public use
  vpc_public_subnets  = slice(local.vpc_subnets, 3, 6)
}

# VPC module configuration
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name               = "aws-lnl-vpc-sr"
  cidr               = local.vpc_cidr
  enable_nat_gateway = true

  # Specify the Availability Zones for the VPC
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
  # Use the calculated private and public subnets
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets
}