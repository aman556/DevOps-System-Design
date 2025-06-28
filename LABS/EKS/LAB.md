# AWS EKS Cluster Setup Labs with Terraform

This manual provides detailed, step-by-step instructions for setting up two AWS EKS (Elastic Kubernetes Service) clusters using Terraform:

- Lab 1: Internal EKS Cluster for Dev Teams/Internal Infra (Private)
- Lab 2: Public EKS Cluster for Hosting Apps (Public)

Each section is self-contained and includes Terraform code samples and commands for an end-to-end (E2E) setup, including VPC creation and EKS provisioning.

---

## Table of Contents

- [Lab 1: Internal EKS Cluster (Private)](#lab-1-internal-eks-cluster-private)
- [Lab 2: Public EKS Cluster (Public)](#lab-2-public-eks-cluster-public)
- [Best Practices and Security](#best-practices-and-security)
- [Resources](#resources)
- [YouTube Walkthrough](#youtube-walkthrough)

---

## Lab 1: Internal EKS Cluster (Private)

### Goal

Deploy an EKS cluster inside a **private VPC**. The cluster will have only private endpoints, with no public access, suitable for dev teams or internal infrastructure.

---

### Step 1: Initialize the Project

```bash
mkdir eks-lab-internal
cd eks-lab-internal
```

Create a `main.tf`, `variables.tf`, and `outputs.tf` for modularity.

---

### Step 2: Provider Setup

```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}
```

---

### Step 3: Create a Private VPC

```hcl
# main.tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-internal-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "internal"
    Terraform   = "true"
  }
}
```

---

### Step 4: Deploy EKS Cluster (Private Endpoint Only)

```hcl
# main.tf
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "eks-internal"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }
  eks_managed_node_groups = {
    internal_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  tags = {
    Environment = "internal"
    Terraform   = "true"
  }
}
```

---

### Step 5: Terraform Workflow

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply to create VPC and EKS
terraform apply
```

---

### Step 6: Accessing the Cluster

Since this cluster is internal/private, you’ll need to connect from a bastion host or a VPN inside the VPC.

```bash
aws eks update-kubeconfig --name eks-internal --region us-east-1
```

If `kubectl` access fails from local, use AWS SSM or a bastion in the same VPC.

---

### Step 7: Outputs

Add outputs in `outputs.tf` if needed:

```hcl
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}
```

---

## Lab 2: Public EKS Cluster (Public)

### Goal

Deploy an EKS cluster in a VPC with public and private subnets. The cluster will have public endpoints and can host applications exposed to the internet.

---

### Step 1: Initialize the Project

```bash
mkdir eks-lab-public
cd eks-lab-public
```

Create a `main.tf`, `variables.tf`, and `outputs.tf`.

---

### Step 2: Provider Setup

```hcl
# main.tf
provider "aws" {
  region = "us-east-1"
}
```

---

### Step 3: Create a VPC with Public and Private Subnets

```hcl
# main.tf
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-public-vpc"
  cidr = "10.1.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.1.1.0/24", "10.1.2.0/24"]
  private_subnets = ["10.1.11.0/24", "10.1.12.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "public"
    Terraform   = "true"
  }
}
```

---

### Step 4: Deploy EKS Cluster (Public Endpoint)

```hcl
# main.tf
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"
  cluster_name    = "eks-public"
  cluster_version = "1.29"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = concat(module.vpc.public_subnets, module.vpc.private_subnets)

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }
  eks_managed_node_groups = {
    public_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_types   = ["t3.medium"]
    }
  }

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  public_access_cidrs            = ["0.0.0.0/0"] # Restrict to your IP range for security

  tags = {
    Environment = "public"
    Terraform   = "true"
  }
}
```

---

### Step 5: Terraform Workflow

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply to create VPC and EKS
terraform apply
```

---

### Step 6: Accessing the Cluster

```bash
aws eks update-kubeconfig --name eks-public --region us-east-1
```

Now you can deploy workloads that are exposed via public LoadBalancers or Ingress controllers.

---

### Step 7: Outputs

Add outputs in `outputs.tf` if needed:

```hcl
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig" {
  value = module.eks.kubeconfig
}
```

---

## Best Practices and Security

- **Use least privilege IAM policies** for cluster and node roles.
- **Restrict public access**: Use `public_access_cidrs` to whitelist IPs.
- **Keep your Terraform state secure** (backend encryption, bucket versioning).
- **Regularly update EKS and node AMIs** for security patches.
- **Enable Kubernetes RBAC** to control access within the cluster.
- **Use private subnets for nodes** and only public subnets for load balancers if possible.
- **Limit SSH access**: Prefer SSM Session Manager over direct SSH.

---

## Resources

- [Terraform AWS VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc)
- [Terraform AWS EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

---

## YouTube Walkthrough

📺 *A step-by-step video guide for these labs will be available on my YouTube channel ([link to be added]).*

---

**Happy Learning!**  
If you have questions, open an issue or comment on the video.
