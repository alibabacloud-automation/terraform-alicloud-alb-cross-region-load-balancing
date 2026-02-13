# CEN Instance Outputs
output "cen_instance_id" {
  description = "The ID of the CEN instance"
  value       = alicloud_cen_instance.cen.id
}

# Transit Router Outputs
output "transit_router_tr1_id" {
  description = "The ID of the transit router in region1"
  value       = module.region1.transit_router_id
}

output "transit_router_tr2_id" {
  description = "The ID of the transit router in region2"
  value       = module.region2.transit_router_id
}

output "transit_router_tr3_id" {
  description = "The ID of the transit router in region3"
  value       = module.region3.transit_router_id
}

# VPC Outputs
output "vpc1_id" {
  description = "The ID of VPC in region1"
  value       = module.region1.vpc_id
}

output "vpc2_id" {
  description = "The ID of VPC in region2"
  value       = module.region2.vpc_id
}

output "vpc3_id" {
  description = "The ID of VPC in region3"
  value       = module.region3.vpc_id
}

output "vpc1_route_table_id" {
  description = "The route table ID of VPC in region1"
  value       = module.region1.vpc_route_table_id
}

output "vpc2_route_table_id" {
  description = "The route table ID of VPC in region2"
  value       = module.region2.vpc_route_table_id
}

output "vpc3_route_table_id" {
  description = "The route table ID of VPC in region3"
  value       = module.region3.vpc_route_table_id
}

# VSwitch Outputs
output "vsw11_id" {
  description = "The ID of VSwitch 11 in region1"
  value       = module.region1.vswitch_ids[0]
}

output "vsw12_id" {
  description = "The ID of VSwitch 12 in region1"
  value       = module.region1.vswitch_ids[1]
}

output "vsw21_id" {
  description = "The ID of VSwitch 21 in region2"
  value       = module.region2.vswitch_ids[0]
}

output "vsw22_id" {
  description = "The ID of VSwitch 22 in region2"
  value       = module.region2.vswitch_ids[1]
}

output "vsw31_id" {
  description = "The ID of VSwitch 31 in region3"
  value       = module.region3.vswitch_ids[0]
}

output "vsw32_id" {
  description = "The ID of VSwitch 32 in region3"
  value       = module.region3.vswitch_ids[1]
}

# Security Group Outputs
output "security_group1_id" {
  description = "The ID of security group in region1"
  value       = module.region1.security_group_id
}

output "security_group2_id" {
  description = "The ID of security group in region2"
  value       = module.region2.security_group_id
}

output "security_group3_id" {
  description = "The ID of security group in region3"
  value       = module.region3.security_group_id
}

# ECS Instance Outputs
output "ecs1_id" {
  description = "The ID of ECS instance in region1"
  value       = module.region1.ecs_id
}

output "ecs2_id" {
  description = "The ID of ECS instance in region2"
  value       = module.region2.ecs_id
}

output "ecs3_id" {
  description = "The ID of ECS instance in region3"
  value       = module.region3.ecs_id
}

output "ecs1_private_ip" {
  description = "The private IP address of ECS instance in region1"
  value       = module.region1.ecs_private_ip
}

output "ecs2_private_ip" {
  description = "The private IP address of ECS instance in region2"
  value       = module.region2.ecs_private_ip
}

output "ecs3_private_ip" {
  description = "The private IP address of ECS instance in region3"
  value       = module.region3.ecs_private_ip
}

# ALB Outputs
output "alb_load_balancer_id" {
  description = "The ID of the ALB load balancer"
  value       = alicloud_alb_load_balancer.alb.id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB load balancer"
  value       = alicloud_alb_load_balancer.alb.dns_name
}

output "alb_server_group_id" {
  description = "The ID of the ALB server group"
  value       = alicloud_alb_server_group.alb_rs.id
}

output "alb_listener_id" {
  description = "The ID of the ALB listener"
  value       = alicloud_alb_listener.alb_listener.id
}

# Transit Router VPC Attachment Outputs
output "vpc_attachment1_id" {
  description = "The ID of VPC attachment to transit router in region1"
  value       = module.region1.vpc_attachment_id
}

output "vpc_attachment2_id" {
  description = "The ID of VPC attachment to transit router in region2"
  value       = module.region2.vpc_attachment_id
}

output "vpc_attachment3_id" {
  description = "The ID of VPC attachment to transit router in region3"
  value       = module.region3.vpc_attachment_id
}

# Transit Router Route Table Outputs
output "tr1_route_table_id" {
  description = "The ID of transit router route table in region1"
  value       = module.region1.transit_router_route_table_id
}

output "tr2_route_table_id" {
  description = "The ID of transit router route table in region2"
  value       = module.region2.transit_router_route_table_id
}

output "tr3_route_table_id" {
  description = "The ID of transit router route table in region3"
  value       = module.region3.transit_router_route_table_id
}

# Transit Router Peer Attachment Outputs
output "peer12_attachment_id" {
  description = "The ID of peer attachment between transit router 1 and 2"
  value       = alicloud_cen_transit_router_peer_attachment.peer12_attachment.transit_router_attachment_id
}

output "peer13_attachment_id" {
  description = "The ID of peer attachment between transit router 1 and 3"
  value       = alicloud_cen_transit_router_peer_attachment.peer13_attachment.transit_router_attachment_id
}