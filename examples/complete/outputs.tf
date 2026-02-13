# Output the key resources created by the module
output "cen_instance_id" {
  description = "The ID of the CEN instance"
  value       = module.alb_cross_region.cen_instance_id
}

output "alb_dns_name" {
  description = "The DNS name of the ALB load balancer"
  value       = module.alb_cross_region.alb_dns_name
}

output "alb_load_balancer_id" {
  description = "The ID of the ALB load balancer"
  value       = module.alb_cross_region.alb_load_balancer_id
}

output "vpc_ids" {
  description = "The IDs of VPCs in all regions"
  value = {
    vpc1 = module.alb_cross_region.vpc1_id
    vpc2 = module.alb_cross_region.vpc2_id
    vpc3 = module.alb_cross_region.vpc3_id
  }
}

output "ecs_private_ips" {
  description = "The private IP addresses of ECS instances"
  value = {
    ecs1 = module.alb_cross_region.ecs1_private_ip
    ecs2 = module.alb_cross_region.ecs2_private_ip
    ecs3 = module.alb_cross_region.ecs3_private_ip
  }
}

output "transit_router_ids" {
  description = "The IDs of transit routers in all regions"
  value = {
    tr1 = module.alb_cross_region.transit_router_tr1_id
    tr2 = module.alb_cross_region.transit_router_tr2_id
    tr3 = module.alb_cross_region.transit_router_tr3_id
  }
}