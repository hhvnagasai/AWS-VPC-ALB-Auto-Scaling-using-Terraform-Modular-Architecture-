variable "stress_mode" {
  description = "Enable stress mode"
  type        = bool
  default     = false
}

variable "normal_scaling" {
  type = object({
    min     = number
    desired = number
    max     = number
  })

  default = {
    min     = 1
    desired = 2
    max     = 3
  }
}

variable "stress_scaling" {
  type = object({
    min     = number
    desired = number
    max     = number
  })

  default = {
    min     = 3
    desired = 4
    max     = 6
  }
}
