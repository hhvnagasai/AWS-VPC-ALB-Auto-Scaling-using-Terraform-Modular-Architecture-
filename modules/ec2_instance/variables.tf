variable "ami_id" {
  description = "Base AMI ID"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "subnet_id" {
  description = "Private subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "EC2 Security Group"
  type        = string
}
