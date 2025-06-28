# AWS EKS Cluster Setup Lab with Terraform

This guide provides a single, streamlined lab for deploying an AWS EKS (Elastic Kubernetes Service) cluster with Terraform. It covers the full workflow: initializing Terraform, applying infrastructure, and cleaning up. All resources (VPC, subnets, EKS, and node group) are managed in a modular, production-like fashion.

---

## Table of Contents

- [Lab Overview](#lab-overview)
- [Terraform Project Structure](#terraform-project-structure)
- [Step-by-Step Instructions](#step-by-step-instructions)
  - [1. Prepare the Project](#1-prepare-the-project)
  - [2. Provider Setup (`provider.tf`)](#2-provider-setup-providertf)
  - [3. VPC, Subnets, and Networking (`vpc.tf`)](#3-vpc-subnets-and-networking-vpctf)
  - [4. EKS Cluster and Node Group (`eks.tf`)](#4-eks-cluster-and-node-group-ekstf)
  - [5. Initialize Terraform](#5-initialize-terraform)
  - [6. Review the Plan](#6-review-the-plan)
  - [7. Apply the Infrastructure](#7-apply-the-infrastructure)
  - [8. Access Your EKS Cluster](#8-access-your-eks-cluster)
  - [9. Destroy the Infrastructure](#9-destroy-the-infrastructure)
- [Best Practices and Security](#best-practices-and-security)
- [Resources](#resources)

---

## Prerequisites

1. **Read the Infrastructure as Code (IaC) Article**

   Please review the IaC foundational article before proceeding:  
   [articles/InfrastructureasCode.md](articles/InfrastructureasCode.md)

2. **Install Terraform and AWS CLI**

   Install required command-line tools using the provided scripts:

   ```bash
   # Install AWS CLI
   bash scripts/install_awscli.sh

   # Install Terraform CLI
   bash scripts/install_terraform.sh
   ```

   Ensure both tools are available in your `PATH` and properly configured.

---

## Lab Overview

You will deploy an EKS cluster into a new VPC with both public and private subnets. Node groups reside in private subnets for security. This pattern is widely used in production and is suitable for most Kubernetes workloads.

---

## Terraform Project Structure

- `provider.tf`: AWS provider configuration.
- `vpc.tf`: VPC, subnet, and networking resources (using the AWS VPC module).
- `eks.tf`: EKS cluster and managed node group (using the AWS EKS module).
- `outputs.tf`: Outputs for cluster endpoint and kubeconfig.

---

## Step-by-Step Instructions

### 1. Prepare the Project

```bash
mkdir eks-lab
cd eks-lab
# Place the provided Terraform files here
```

---

### 2. Provider Setup (`provider.tf`)

This file configures Terraform to use AWS and sets the region.

```hcl
# Configure the AWS provider and region for all resources
provider "aws" {
  region = "us-east-1"
}
```

---

### 3. VPC, Subnets, and Networking (`vpc.tf`)

This block creates a VPC with three public and three private subnets, spreading them across three availability zones for high availability. A NAT Gateway allows private subnets to access the internet.

```hcl
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
```

---

### 4. EKS Cluster and Node Group (`eks.tf`)

This block provisions an EKS cluster in the private subnets and a managed node group.

```hcl
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
```

---

### 5. Initialize Terraform

```bash
terraform init
```
This downloads required modules and sets up the working directory.

---

### 6. Review the Plan

```bash
terraform plan
```
Shows the resources Terraform will create or change.

---

### 7. Apply the Infrastructure

```bash
terraform apply
```
Provision the infrastructure. Confirm when prompted.

---

### 8. Access Your EKS Cluster

Update your local kubeconfig file:

```bash
aws eks update-kubeconfig --name eks-cluster --region us-east-1
```
You can now interact with your cluster using `kubectl`.  
If your endpoint is private, connect from a host within the VPC (e.g., via SSM or a bastion).

---

### 9. Destroy the Infrastructure

To clean up all resources safely:

```bash
terraform destroy
```
Confirm when prompted. This ensures you don’t accrue unnecessary AWS charges.

---

## Best Practices and Security

- **Use least privilege IAM roles** for clusters and nodes.
- **Restrict public access** to the EKS endpoint unless required.
- **Keep Terraform state secure** (e.g., use S3 with encryption and versioning).
- **Update EKS versions and node AMIs regularly**.
- **Limit SSH access**; prefer AWS SSM Session Manager for node access.

---

## Resources

- [Terraform AWS VPC Module](https://github.com/terraform-aws-modules/terraform-aws-vpc)
- [Terraform AWS EKS Module](https://github.com/terraform-aws-modules/terraform-aws-eks)
- [AWS EKS Documentation](https://docs.aws.amazon.com/eks/latest/userguide/what-is-eks.html)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)

---
