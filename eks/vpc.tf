locals {
  vpc_cidr = "10.0.0.0/16"


  vpc_subnets = cidrsubnets(local.vpc_cidr, 3, 3, 3, 3, 3, 3)

  vpc_private_subnets = slice(local.vpc_subnets, 0, 3)
  vpc_public_subnets  = slice(local.vpc_subnets, 3, 6)
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name               = "aws-lnl-eks-vpc"
  cidr               = local.vpc_cidr
  enable_nat_gateway = true

  azs             = ["us-west-2a", "us-west-2b", "us-west-2c"]
  private_subnets = local.vpc_private_subnets
  public_subnets  = local.vpc_public_subnets

}