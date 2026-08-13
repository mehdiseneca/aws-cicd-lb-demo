variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix used for tagging resources"
  type        = string
  default     = "cicd-lb-demo"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 web servers behind the load balancer"
  type        = number
  default     = 4 # changed from 2 to 4
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into instances (use YOUR_IP/32 ideally)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "key_name" {
  description = "Existing EC2 key pair name for SSH access (leave blank to skip)"
  type        = string
  default     = ""
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the CI/CD IAM role, format: owner/repo"
  type        = string
  default     = "mehdiseneca/aws-cicd-lb-demo"
}

variable "github_oidc_subject_prefix" {
  description = "Exact subject claim prefix from GitHub Settings -> Actions -> General -> OIDC configuration"
  type        = string
  default     = "repo:mehdiseneca@93612198/aws-cicd-lb-demo-@1332466388"
}
