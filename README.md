# KM-Cloud — AWS Terraform Infrastructure

Production-grade, modular AWS Infrastructure as Code (IaC) built by **Khush Makwana**. Fully configured for **ap-south-1 (Mumbai)** and strictly optimized to stay **100% within the AWS Free Tier**.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured with valid credentials (`ap-south-1`)
- An AWS account (Configured for AWS Free Tier)

## Versions & Region

| Parameter | Value |
|-----------|-------|
| Terraform | >= 1.5.0 |
| AWS Provider | ~> 6.0 |
| Default Region | `ap-south-1` (Asia Pacific - Mumbai) |
| Compute Tier | `t2.micro` (100% Free Tier eligible) |

## Repository Structure

```
km-cloud-infrastructure/
├── terraform.tf          # Provider config & version constraints
├── variables.tf          # Input variables with validation (ap-south-1 default)
├── ec2.tf                # EC2 instance (Free Tier), Security Group, Key Pair
├── s3.tf                 # S3 bucket with versioning & SSE encryption
├── dynamodb.tf           # DynamoDB table (PAY_PER_REQUEST on-demand)
├── outputs.tf            # Output values (ARNs, Public IPs)
├── script.sh             # EC2 user_data bootstrap script (Nginx)
├── khush-key.pub         # SSH public key
│
└── aws_module_project/   # Reusable Modules architecture
    ├── terraform.tf      # Provider version constraints
    ├── providers.tf      # AWS provider region
    ├── main.tf           # Module composition (dev, stg, prd)
    └── my_app_infra_module/  # The reusable module
        ├── variables.tf  # Module inputs with validation
        ├── my_server.tf  # EC2 instances (count)
        ├── my_bucket.tf  # S3 bucket
        ├── my_table.tf   # DynamoDB table
        └── my_outputs.tf # Module outputs
```

## Architecture & Engineering Highlights

I structured this repository around production DevOps principles, emphasizing reusability, security, and strict AWS Free Tier cost control:

| Component | Engineering Implementation | Files |
|:---|:---|:---|
| **Dynamic AMI Discovery** | Automated Ubuntu 22.04 LTS AMI resolution in `ap-south-1` via `data "aws_ami"`, eliminating broken or hardcoded region AMIs. | [`ec2.tf`](ec2.tf) |
| **Compute & Bootstrapping** | Automated Nginx web server installation via EC2 `user_data` script with least-privilege security group ingress (ports 22, 80). | [`ec2.tf`](ec2.tf), [`script.sh`](script.sh) |
| **Secure Object Storage** | S3 bucket hardened with AES-256 server-side encryption, versioning enabled, and explicit public access blocks. | [`s3.tf`](s3.tf) |
| **On-Demand Database** | DynamoDB running in `PAY_PER_REQUEST` billing mode, providing zero idle cost while maintaining fast key-value lookups. | [`dynamodb.tf`](dynamodb.tf) |
| **Input Validation Guardrails** | Custom HCL `validation` blocks enforcing allowed environments (`dev`, `staging`, `prd`), instance types (`t2.micro`), and capping instances at 3. | [`variables.tf`](variables.tf) |
| **Reusable Child Module** | Modularized infrastructure in `aws_module_project/` using [`my_app_infra_module`](aws_module_project/my_app_infra_module) to stamp out consistent, isolated `dev`, `stg`, and `prd` stacks. | [`aws_module_project/main.tf`](aws_module_project/main.tf) |
| **Free-Tier Cost Optimization** | Strictly pinned to `t2.micro` instances and capped to a maximum of 3 instances (30 GB total EBS) to guarantee $0 AWS bills. | [`variables.tf`](variables.tf) |

---

## Deployment & Usage Workflow

### 1. Root Infrastructure Deployment

Initialize providers and review execution plan:
```sh
# Initialize AWS provider and modules
terraform init

# Validate configuration syntax
terraform validate

# Preview changes against AWS ap-south-1
terraform plan

# Apply infrastructure
terraform apply
```

### 2. Multi-Environment Modular Deployment

To deploy isolated application stacks (`dev`, `stg`, `prd`):
```sh
cd aws_module_project

# Initialize child module and provider
terraform init

# Review multi-environment plan
terraform plan

# Deploy all three environments
terraform apply
```

### 3. Teardown & Cleanup

Always clean up lab resources after verification to ensure zero ongoing usage:
```sh
terraform destroy
```

---

## Author

**Khush Makwana** — Cloud & DevOps Engineer
- Multi-Environment AWS Infrastructure with Terraform & CI/CD automation
- Region: `ap-south-1` (Mumbai) | Designed for High Availability and Free Tier Cost Optimization

