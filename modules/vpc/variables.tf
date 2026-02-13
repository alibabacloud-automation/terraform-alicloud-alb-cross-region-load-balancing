variable "transit_router_name" {
  description = "The name of the transit router"
  type        = string
  default     = null
}

variable "cen_id" {
  description = "The ID of the CEN instance"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "The CIDR block of the VPC"
  type        = string
}

variable "vswitch_configs" {
  description = "Configuration for VSwitches"
  type = list(object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string)
  }))
}

variable "security_group_name" {
  description = "The name of the security group"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "The description of the security group"
  type        = string
  default     = "Security group for ALB cross-region load balancing"
}

variable "security_group_rules" {
  description = "List of security group rules"
  type = list(object({
    type        = optional(string, "ingress")
    ip_protocol = optional(string, "all")
    nic_type    = optional(string, "intranet")
    policy      = optional(string, "accept")
    port_range  = optional(string, "-1/-1")
    priority    = optional(number, 1)
    cidr_ip     = optional(string, "0.0.0.0/0")
  }))
  default = [
    {
      type        = "ingress"
      ip_protocol = "all"
      nic_type    = "intranet"
      policy      = "accept"
      port_range  = "-1/-1"
      priority    = 1
      cidr_ip     = "0.0.0.0/0"
    }
  ]
}

variable "ecs_name" {
  description = "The name of the ECS instance"
  type        = string
  default     = null
}

variable "ecs_instance_type" {
  description = "The instance type for the ECS instance"
  type        = string
}

variable "ecs_image_id" {
  description = "The image ID for the ECS instance"
  type        = string
}

variable "ecs_password" {
  description = "The password for the ECS instance"
  type        = string
  sensitive   = true
}

variable "ecs_system_disk_type" {
  description = "The system disk type of the ECS instance"
  type        = string
}

variable "ecs_user_data" {
  description = "The user data for the ECS instance"
  type        = string
  default     = ""
}

variable "vpc_route_cidrs" {
  description = "List of CIDR blocks for VPC route entries"
  type        = list(string)
  default     = []
}
