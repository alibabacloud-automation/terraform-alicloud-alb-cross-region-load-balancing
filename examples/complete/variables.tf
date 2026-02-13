variable "region1" {
  description = "The first region for ALB cross-region load balancing"
  type        = string
  default     = "cn-chengdu"
}

variable "region2" {
  description = "The second region for ALB cross-region load balancing"
  type        = string
  default     = "cn-shanghai"
}

variable "region3" {
  description = "The third region for ALB cross-region load balancing"
  type        = string
  default     = "cn-qingdao"
}

variable "cen_instance_name" {
  description = "The name of the CEN instance"
  type        = string
  default     = "alb-cross-region-cen"
}

variable "tr1_name" {
  description = "The name of transit router in region1"
  type        = string
  default     = "TR1"
}

variable "tr2_name" {
  description = "The name of transit router in region2"
  type        = string
  default     = "TR2"
}

variable "tr3_name" {
  description = "The name of transit router in region3"
  type        = string
  default     = "TR3"
}

variable "vpc1_name" {
  description = "The name of VPC in region1"
  type        = string
  default     = "vpc1-test"
}

variable "vpc1_cidr" {
  description = "The CIDR block of VPC in region1"
  type        = string
  default     = "172.16.0.0/16"
}

variable "vpc2_name" {
  description = "The name of VPC in region2"
  type        = string
  default     = "vpc2-test"
}

variable "vpc2_cidr" {
  description = "The CIDR block of VPC in region2"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc3_name" {
  description = "The name of VPC in region3"
  type        = string
  default     = "vpc3-test"
}

variable "vpc3_cidr" {
  description = "The CIDR block of VPC in region3"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vsw11_cidr" {
  description = "The CIDR block of VSwitch 11 in region1"
  type        = string
  default     = "172.16.20.0/24"
}

variable "vsw12_cidr" {
  description = "The CIDR block of VSwitch 12 in region1"
  type        = string
  default     = "172.16.21.0/24"
}

variable "vsw21_cidr" {
  description = "The CIDR block of VSwitch 21 in region2"
  type        = string
  default     = "10.0.20.0/24"
}

variable "vsw22_cidr" {
  description = "The CIDR block of VSwitch 22 in region2"
  type        = string
  default     = "10.0.21.0/24"
}

variable "vsw31_cidr" {
  description = "The CIDR block of VSwitch 31 in region3"
  type        = string
  default     = "192.168.20.0/24"
}

variable "vsw32_cidr" {
  description = "The CIDR block of VSwitch 32 in region3"
  type        = string
  default     = "192.168.21.0/24"
}

variable "vsw11_name" {
  description = "The name of VSwitch 11 in region1"
  type        = string
  default     = "vsw11"
}

variable "vsw12_name" {
  description = "The name of VSwitch 12 in region1"
  type        = string
  default     = "vsw12"
}

variable "vsw21_name" {
  description = "The name of VSwitch 21 in region2"
  type        = string
  default     = "vsw21"
}

variable "vsw22_name" {
  description = "The name of VSwitch 22 in region2"
  type        = string
  default     = "vsw22"
}

variable "vsw31_name" {
  description = "The name of VSwitch 31 in region3"
  type        = string
  default     = "vsw31"
}

variable "vsw32_name" {
  description = "The name of VSwitch 32 in region3"
  type        = string
  default     = "vsw32"
}

variable "group1_name" {
  description = "The name of security group in region1"
  type        = string
  default     = "sg-region1"
}

variable "group2_name" {
  description = "The name of security group in region2"
  type        = string
  default     = "sg-region2"
}

variable "group3_name" {
  description = "The name of security group in region3"
  type        = string
  default     = "sg-region3"
}

variable "system_disk_category" {
  description = "The system disk category for ECS instances"
  type        = string
  default     = "cloud_essd"
}

variable "image_id" {
  description = "The image ID for ECS instances"
  type        = string
  default     = "aliyun_3_x64_20G_alibase_20230727.vhd"
}

variable "ecs_password" {
  description = "The password for ECS instances"
  type        = string
  default     = "Test12345!"
  sensitive   = true
}

variable "ecs1_name" {
  description = "The name of ECS instance in region1"
  type        = string
  default     = "ECS1"
}

variable "ecs2_name" {
  description = "The name of ECS instance in region2"
  type        = string
  default     = "ECS2"
}

variable "ecs3_name" {
  description = "The name of ECS instance in region3"
  type        = string
  default     = "ECS3"
}

variable "alb_name" {
  description = "The name of ALB load balancer"
  type        = string
  default     = "alb-cross-region"
}

variable "alb_server_group_name" {
  description = "The name of ALB server group"
  type        = string
  default     = "alb-server-group"
}

variable "peer12_name" {
  description = "The name of peer attachment between region1 and region2"
  type        = string
  default     = "TR1-TR2-Cross-Region"
}

variable "peer13_name" {
  description = "The name of peer attachment between region1 and region3"
  type        = string
  default     = "TR1-TR3-Cross-Region"
}

variable "alb_back_to_source_routing_cidrs" {
  description = "List of CIDR blocks for ALB back-to-source routing"
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