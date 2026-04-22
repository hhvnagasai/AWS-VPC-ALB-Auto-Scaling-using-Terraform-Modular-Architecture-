variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "port" {
  description = "Application port"
  type        = number
}

variable "protocol" {
  description = "Protocol"
  type        = string
}
