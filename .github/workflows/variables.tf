// Taken from the OSname.tfvars

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "availability_zone" {
  description = "List of availability zone in the region"
  default     = "us-east-1b"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  default     = "t3.micro"
  type        = string
}

variable "ami_key_pair_name" {
  description = "Name of key pair in AWS thats used"
  default     = "Lockdown_enterprise_workflow-sshkey"
  type        = string
}

variable "ami_os" {
  description = "AMI OS Type"
  type        = string
}

variable "ami_id" {
  description = "AMI ID reference"
  type        = string
}

variable "ami_username" {
  description = "Username for the ami id"
  type        = string
}

variable "ami_user_home" {
  description = "home dir for the username"
  type        = string
}

variable "namespace" {
  description = "Name used across all tags"
  default     = "Lockdown_enterprise_workflow"
  type        = string
}

variable "environment" {
  description = "Env Name used across all tags"
  type        = string
  default     = "Ansible_Lockdown_Environment"
}

variable "benchmark_os" {
  description = "The benchmark OS thats being tested"
  type        = string
}

variable "benchmark_type" {
  description = "The benchmark OS thats being tested"
  type        = string
}

variable "vpc_secgrp_id" {
  description = "The id of the vpc security group for the runner"
  type        = string
  sensitive   = true
}

variable "privsubnet_id" {
  description = "The id of the private subnet for the runner vpc"
  type        = string
  sensitive   = true
}
