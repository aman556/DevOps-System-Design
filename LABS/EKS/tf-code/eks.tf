# EKS module: provisions the cluster and a managed node group in private subnets.
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.4"

  cluster_name    = "eks-cluster"
  cluster_version = "1.32"

  # Deploy EKS only in private subnets for security.
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  # Managed Node Group: single node group for workloads.
  eks_managed_node_groups = {
    default = {
      desired_capacity = 1
      min_capacity     = 1
      max_capacity     = 1
      instance_types   = ["t3.medium"] # Choose the instance type for nodes.
    }
  }

  # Tags for resources.
  tags = {
    Environment = "lab"
    Terraform   = "true"
  }
}
