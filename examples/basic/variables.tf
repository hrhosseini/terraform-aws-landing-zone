variable "project" {
  description = "Project/organization short name."
  type        = string
  default     = "example"
}

variable "environment" {
  description = "Environment name."
  type        = string
  default     = "sandbox"
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "eu-west-1"
}
