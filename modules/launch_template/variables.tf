variable "ami_id" {
  description = "Custom AMI ID"
  type        = string
}

variable "instance_type" {
  type = string
}

variable "security_group_id" {
  description = "EC2 Security Group"
  type        = string
}
