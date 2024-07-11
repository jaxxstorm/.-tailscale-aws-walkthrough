# Define an EKS (Elastic Kubernetes Service) cluster using the terraform-aws-modules/eks/aws module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  # Set the name and Kubernetes version for the EKS cluster
  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  # Allow public access to the cluster endpoint
  cluster_endpoint_public_access = true

  # Configure cluster add-ons, using the most recent versions
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # Specify the VPC and subnet configuration for the cluster
  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # Set default configuration for EKS managed node groups
  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  # Define an EKS managed node group
  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"  # Use spot instances for cost optimization
    }
  }

  # Enable permissions for the cluster creator to have admin access
  enable_cluster_creator_admin_permissions = true

  # Add tags to the EKS cluster resources
  tags = {
    Environment = "dev"
    Terraform   = "true"
    Owner       = "lbriggs"
  }
}