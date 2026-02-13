output "transit_router_id" {
  description = "The ID of the transit router"
  value       = alicloud_cen_transit_router.tr.transit_router_id
}

output "transit_router_name" {
  description = "The name of the transit router"
  value       = alicloud_cen_transit_router.tr.transit_router_name
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_route_table_id" {
  description = "The route table ID of the VPC"
  value       = alicloud_vpc.vpc.route_table_id
}

output "vswitch_ids" {
  description = "The IDs of the VSwitches"
  value       = alicloud_vswitch.vsw[*].id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.group.id
}

output "ecs_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs.id
}

output "ecs_private_ip" {
  description = "The private IP of the ECS instance"
  value       = alicloud_instance.ecs.private_ip
}

output "vpc_attachment_id" {
  description = "The ID of the VPC attachment to transit router"
  value       = alicloud_cen_transit_router_vpc_attachment.vpc_att.transit_router_attachment_id
}

output "transit_router_route_table_id" {
  description = "The ID of the transit router route table"
  value       = alicloud_cen_transit_router_route_table.tr_route_table.transit_router_route_table_id
}
