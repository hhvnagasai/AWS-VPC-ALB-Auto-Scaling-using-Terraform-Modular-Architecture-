variable "subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "ALB Security Group"
  type        = string
}

variable "target_group_arn" {
  description = "Target Group ARN"
  type        = string
}
