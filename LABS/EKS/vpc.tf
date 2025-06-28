# VPC module: creates a new VPC, public/private subnets, routing, and NAT Gateway.
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  # Spread subnets across three Availability Zones for high availability.
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]

  # Enable a single NAT gateway for outbound internet access from private subnets.
  enable_nat_gateway = true
  single_nat_gateway = true

  # Tagging for identification and automation.
  tags = {
    Environment = "lab"
    Terraform   = "true"
  }
}
