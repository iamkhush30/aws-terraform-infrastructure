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

## What You'll Learn

| Concept | Where to Find It |
|---------|-----------------|
| Provider & version constraints | `terraform.tf` |
| Variables with validation | `variables.tf` |
| EC2, Security Groups, Key Pairs | `ec2.tf` |
| user_data bootstrapping | `ec2.tf` + `script.sh` |
| S3 with versioning & encryption | `s3.tf` |
| DynamoDB tables | `dynamodb.tf` |
| Outputs | `outputs.tf` |
| Reusable modules | `aws_module_project/` |
| Multi-environment with modules | `aws_module_project/main.tf` |

---

## Terraform Commands — Complete Guide

### 1. Setup & Initialization

**Install Terraform (Linux/Ubuntu)**
```sh
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

# Verify installation
terraform -v
```

**Install Terraform (macOS)**
```sh
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
```

**Initialize Terraform**
```sh
terraform init
```
- Downloads provider plugins
- Sets up the working directory

### 2. Core Commands
```sh
terraform fmt           # Format code to standard style
terraform validate      # Validate syntax and configuration
terraform plan          # Preview changes without applying
terraform apply         # Create/update infrastructure
terraform apply -auto-approve  # Apply without confirmation
terraform destroy       # Destroy all managed resources
terraform destroy -auto-approve  # Destroy without confirmation
```

### 3. Managing State
```sh
terraform state list              # List all managed resources
terraform show                    # Show detailed resource info
terraform state mv <src> <dest>   # Move resource in state
terraform state rm <resource>     # Remove from state (not from cloud)
```

**Remote Backend (S3 + DynamoDB for locking)**
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
```

### 4. Variables & Outputs
```sh
terraform apply -var="instance_type=t3.small"  # Pass variable via CLI
terraform output                                # Show all outputs
terraform output ec2_public_ip                  # Show specific output
```

### 5. Workspaces
```sh
terraform workspace new dev       # Create workspace
terraform workspace select prod   # Switch workspace
terraform workspace list          # List all workspaces
```

### 6. Testing (Terraform 1.6+)
```sh
terraform test                    # Run all .tftest.hcl files
```

### 7. Debugging
```sh
export TF_LOG=DEBUG               # Enable debug logs
terraform apply 2>&1 | tee debug.log
```

---

## Author

**Khush Makwana** — Cloud & DevOps Engineer
- Multi-Environment AWS Infrastructure with Terraform & CI/CD automation
- Region: `ap-south-1` (Mumbai) | Designed for High Availability and Free Tier Cost Optimization

