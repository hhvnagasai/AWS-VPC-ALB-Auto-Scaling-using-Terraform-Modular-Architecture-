variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cidr_block" {
  description = "Subnet CIDR"
  type        = string
}

variable "availability_zone" {
  description = "AZ for subnet"
  type        = string
}
