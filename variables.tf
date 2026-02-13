variable "cen_config" {
  description = "The parameters of CEN instance. The attribute 'cen_instance_name' is required."
  type = object({
    cen_instance_name = string
    description       = optional(string, "CEN instance for cross-region load balancing")
  })
  default = {
    cen_instance_name = null
  }
}

variable "region1_network_config" {
  description = "Network configuration for Region 1 (ALB deployment region). Includes Transit Router, VPC, VSwitches, and routing."
  type = object({
    # Transit Router
    transit_router_name = optional(string, "tr-alb-region")
    # VPC
    vpc_name = optional(string, "vpc-alb-region")
    vpc_cidr = string
    # VSwitches
    vswitch_configs = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, "vsw-alb")
    }))
    # VPC Route CIDRs
    vpc_route_cidrs = list(string)
  })
}

variable "region1_security_group_config" {
  description = "Security group configuration for Region 1."
  type = object({
    security_group_name        = string
    security_group_description = optional(string, "Security group for ALB cross-region load balancing")
    # Security Group Rules
    security_group_rules = optional(list(object({
      type        = optional(string, "ingress")
      ip_protocol = optional(string, "all")
      nic_type    = optional(string, "intranet")
      policy      = optional(string, "accept")
      port_range  = optional(string, "-1/-1")
      priority    = optional(number, 1)
      cidr_ip     = optional(string, "0.0.0.0/0")
      })), [
      {
        type        = "ingress"
        ip_protocol = "all"
        nic_type    = "intranet"
        policy      = "accept"
        port_range  = "-1/-1"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
      }
    ])
  })
}

variable "region1_ecs_config" {
  description = "ECS instance configuration for Region 1."
  type = object({
    ecs_name             = optional(string, "ECS1")
    ecs_instance_type    = string
    ecs_image_id         = string
    ecs_password         = string
    ecs_system_disk_type = string
    ecs_user_data        = optional(string, "#!/bin/sh\necho \"Hello World ! This is ECS01.\" > index.html\nnohup python3 -m http.server 80 &")
  })
  sensitive = true
}

variable "region2_network_config" {
  description = "Network configuration for Region 2 (Backend region). Includes Transit Router, VPC, VSwitches, and routing."
  type = object({
    # Transit Router
    transit_router_name = optional(string, "tr-backend-region2")
    # VPC
    vpc_name = optional(string, "vpc-backend-region2")
    vpc_cidr = string
    # VSwitches
    vswitch_configs = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, "vsw-backend")
    }))
    # VPC Route CIDRs
    vpc_route_cidrs = list(string)
    # Peer Attachment Name
    peer_attachment_name = optional(string, "peer-alb-to-backend2")
  })
}

variable "region2_security_group_config" {
  description = "Security group configuration for Region 2."
  type = object({
    security_group_name        = string
    security_group_description = optional(string, "Security group for ALB cross-region load balancing")
    # Security Group Rules
    security_group_rules = optional(list(object({
      type        = optional(string, "ingress")
      ip_protocol = optional(string, "all")
      nic_type    = optional(string, "intranet")
      policy      = optional(string, "accept")
      port_range  = optional(string, "-1/-1")
      priority    = optional(number, 1)
      cidr_ip     = optional(string, "0.0.0.0/0")
      })), [
      {
        type        = "ingress"
        ip_protocol = "all"
        nic_type    = "intranet"
        policy      = "accept"
        port_range  = "-1/-1"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
      }
    ])
  })
}

variable "region2_ecs_config" {
  description = "ECS instance configuration for Region 2."
  type = object({
    ecs_name             = optional(string, "ECS2")
    ecs_instance_type    = string
    ecs_image_id         = string
    ecs_password         = string
    ecs_system_disk_type = string
    ecs_user_data        = optional(string, "#!/bin/sh\necho \"Hello World ! This is ECS02.\" > index.html\nnohup python3 -m http.server 80 &")
  })
  sensitive = true
}

variable "region3_network_config" {
  description = "Network configuration for Region 3 (Backend region). Includes Transit Router, VPC, VSwitches, and routing."
  type = object({
    # Transit Router
    transit_router_name = optional(string, "tr-backend-region3")
    # VPC
    vpc_name = optional(string, "vpc-backend-region3")
    vpc_cidr = string
    # VSwitches
    vswitch_configs = list(object({
      zone_id      = string
      cidr_block   = string
      vswitch_name = optional(string, "vsw-backend")
    }))
    # VPC Route CIDRs
    vpc_route_cidrs = list(string)
    # Peer Attachment Name
    peer_attachment_name = optional(string, "peer-alb-to-backend3")
  })
}

variable "region3_security_group_config" {
  description = "Security group configuration for Region 3."
  type = object({
    security_group_name        = string
    security_group_description = optional(string, "Security group for ALB cross-region load balancing")
    # Security Group Rules
    security_group_rules = optional(list(object({
      type        = optional(string, "ingress")
      ip_protocol = optional(string, "all")
      nic_type    = optional(string, "intranet")
      policy      = optional(string, "accept")
      port_range  = optional(string, "-1/-1")
      priority    = optional(number, 1)
      cidr_ip     = optional(string, "0.0.0.0/0")
      })), [
      {
        type        = "ingress"
        ip_protocol = "all"
        nic_type    = "intranet"
        policy      = "accept"
        port_range  = "-1/-1"
        priority    = 1
        cidr_ip     = "0.0.0.0/0"
      }
    ])
  })
}

variable "region3_ecs_config" {
  description = "ECS instance configuration for Region 3."
  type = object({
    ecs_name             = optional(string, "ECS3")
    ecs_instance_type    = string
    ecs_image_id         = string
    ecs_password         = string
    ecs_system_disk_type = string
    ecs_user_data        = optional(string, "#!/bin/sh\necho \"Hello World ! This is ECS03.\" > index.html\nnohup python3 -m http.server 80 &")
  })
  sensitive = true
}

variable "alb_config" {
  description = "The parameters of ALB load balancer. The attributes 'load_balancer_name' is required."
  type = object({
    address_type           = optional(string, "Intranet")
    address_allocated_mode = optional(string, "Fixed")
    load_balancer_name     = string
    load_balancer_edition  = optional(string, "Basic")
    pay_type               = optional(string, "PayAsYouGo")
  })
  default = {
    load_balancer_name = null
  }
}

variable "alb_server_group_config" {
  description = "The parameters of ALB server group. The attribute 'server_group_name' is required."
  type = object({
    protocol               = optional(string, "HTTP")
    server_group_name      = string
    server_group_type      = optional(string, "Ip")
    health_check_enabled   = optional(bool, false)
    sticky_session_enabled = optional(bool, false)
    server_port            = optional(number, 80)
    server_type            = optional(string, "Ip")
    remote_ip_enabled      = optional(bool, true)
    server_weight          = optional(number, 100)
  })
  default = {
    server_group_name = null
  }
}

variable "alb_listener_config" {
  description = "The parameters of ALB listener."
  type = object({
    listener_protocol   = optional(string, "HTTP")
    listener_port       = optional(number, 80)
    default_action_type = optional(string, "ForwardGroup")
  })
  default = {}
}

variable "alb_back_to_source_routing_cidrs" {
  description = "List of CIDR blocks for ALB back-to-source routing."
  type        = list(string)
  default = [
    "100.117.130.0/25",
    "100.117.130.128/25",
    "100.117.131.0/25",
    "100.117.131.128/25",
    "100.122.175.64/26",
    "100.122.175.128/26",
    "100.122.175.192/26",
    "100.122.176.0/26"
  ]
}

variable "peer_attachment_auto_publish_route_enabled" {
  description = "Whether to enable auto publish route for transit router peer attachments."
  type        = bool
  default     = true
}