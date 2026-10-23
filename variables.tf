variable "aws_region" {
  description = "AWS region where resources will be provisioned"
  type        = string
  default     = "ap-south-1"
}

variable "instance_count" {
  description = "Number of EC2 instances to provision (maximum 3 for AWS Free Tier 30GB EBS limit)"
  type        = number
  default     = 3

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 3
    error_message = "Instance count must be between 1 and 3."
  }
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium", "t3.micro", "t3.small", "t3.medium"], var.instance_type)
    error_message = "Instance type must be one of: t2.micro, t2.small, t2.medium, t3.micro, t3.small, t3.medium."
  }
}

variable "my_environment" {
  description = "Deployment environment (dev, staging, prd)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prd"], var.my_environment)
    error_message = "Environment must be one of: dev, staging, prd."
  }
}
