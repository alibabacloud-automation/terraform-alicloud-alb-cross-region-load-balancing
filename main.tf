# Enable CEN Transit Router Service
data "alicloud_cen_transit_router_service" "open" {
  enable = "On"
}

# Data sources to get current region IDs
data "alicloud_regions" "region2" {
  provider = alicloud.region2
  current  = true
}

data "alicloud_regions" "region3" {
  provider = alicloud.region3
  current  = true
}

# CEN Instance
resource "alicloud_cen_instance" "cen" {
  provider          = alicloud.region1
  cen_instance_name = var.cen_config.cen_instance_name
  description       = var.cen_config.description

  depends_on = [data.alicloud_cen_transit_router_service.open]
}

# Region 1 Resources
module "region1" {
  source = "./modules/vpc"
  providers = {
    alicloud = alicloud.region1
  }

  transit_router_name        = var.region1_network_config.transit_router_name
  cen_id                     = alicloud_cen_instance.cen.id
  vpc_name                   = var.region1_network_config.vpc_name
  vpc_cidr                   = var.region1_network_config.vpc_cidr
  vswitch_configs            = var.region1_network_config.vswitch_configs
  security_group_name        = var.region1_security_group_config.security_group_name
  security_group_description = var.region1_security_group_config.security_group_description
  security_group_rules       = var.region1_security_group_config.security_group_rules
  ecs_name                   = var.region1_ecs_config.ecs_name
  ecs_instance_type          = var.region1_ecs_config.ecs_instance_type
  ecs_image_id               = var.region1_ecs_config.ecs_image_id
  ecs_password               = var.region1_ecs_config.ecs_password
  ecs_system_disk_type       = var.region1_ecs_config.ecs_system_disk_type
  ecs_user_data              = var.region1_ecs_config.ecs_user_data
  vpc_route_cidrs            = var.region1_network_config.vpc_route_cidrs
}

# Region 2 Resources
module "region2" {
  source = "./modules/vpc"
  providers = {
    alicloud = alicloud.region2
  }

  transit_router_name        = var.region2_network_config.transit_router_name
  cen_id                     = alicloud_cen_instance.cen.id
  vpc_name                   = var.region2_network_config.vpc_name
  vpc_cidr                   = var.region2_network_config.vpc_cidr
  vswitch_configs            = var.region2_network_config.vswitch_configs
  security_group_name        = var.region2_security_group_config.security_group_name
  security_group_description = var.region2_security_group_config.security_group_description
  security_group_rules       = var.region2_security_group_config.security_group_rules
  ecs_name                   = var.region2_ecs_config.ecs_name
  ecs_instance_type          = var.region2_ecs_config.ecs_instance_type
  ecs_image_id               = var.region2_ecs_config.ecs_image_id
  ecs_password               = var.region2_ecs_config.ecs_password
  ecs_system_disk_type       = var.region2_ecs_config.ecs_system_disk_type
  ecs_user_data              = var.region2_ecs_config.ecs_user_data
  vpc_route_cidrs            = var.region2_network_config.vpc_route_cidrs
}

# Region 3 Resources
module "region3" {
  source = "./modules/vpc"
  providers = {
    alicloud = alicloud.region3
  }

  transit_router_name        = var.region3_network_config.transit_router_name
  cen_id                     = alicloud_cen_instance.cen.id
  vpc_name                   = var.region3_network_config.vpc_name
  vpc_cidr                   = var.region3_network_config.vpc_cidr
  vswitch_configs            = var.region3_network_config.vswitch_configs
  security_group_name        = var.region3_security_group_config.security_group_name
  security_group_description = var.region3_security_group_config.security_group_description
  security_group_rules       = var.region3_security_group_config.security_group_rules
  ecs_name                   = var.region3_ecs_config.ecs_name
  ecs_instance_type          = var.region3_ecs_config.ecs_instance_type
  ecs_image_id               = var.region3_ecs_config.ecs_image_id
  ecs_password               = var.region3_ecs_config.ecs_password
  ecs_system_disk_type       = var.region3_ecs_config.ecs_system_disk_type
  ecs_user_data              = var.region3_ecs_config.ecs_user_data
  vpc_route_cidrs            = var.region3_network_config.vpc_route_cidrs
}

# ALB Load Balancer
resource "alicloud_alb_load_balancer" "alb" {
  provider               = alicloud.region1
  vpc_id                 = module.region1.vpc_id
  address_type           = var.alb_config.address_type
  address_allocated_mode = var.alb_config.address_allocated_mode
  load_balancer_name     = var.alb_config.load_balancer_name
  load_balancer_edition  = var.alb_config.load_balancer_edition

  load_balancer_billing_config {
    pay_type = var.alb_config.pay_type
  }

  zone_mappings {
    vswitch_id = module.region1.vswitch_ids[0]
    zone_id    = var.region1_network_config.vswitch_configs[0].zone_id
  }

  zone_mappings {
    vswitch_id = module.region1.vswitch_ids[1]
    zone_id    = var.region1_network_config.vswitch_configs[1].zone_id
  }
}

# ALB Server Group
resource "alicloud_alb_server_group" "alb_rs" {
  provider          = alicloud.region1
  protocol          = var.alb_server_group_config.protocol
  vpc_id            = module.region1.vpc_id
  server_group_name = var.alb_server_group_config.server_group_name
  server_group_type = var.alb_server_group_config.server_group_type

  health_check_config {
    health_check_enabled = var.alb_server_group_config.health_check_enabled
  }

  sticky_session_config {
    sticky_session_enabled = var.alb_server_group_config.sticky_session_enabled
  }

  servers {
    port              = var.alb_server_group_config.server_port
    server_id         = module.region2.ecs_private_ip
    server_ip         = module.region2.ecs_private_ip
    server_type       = var.alb_server_group_config.server_type
    remote_ip_enabled = var.alb_server_group_config.remote_ip_enabled
    weight            = var.alb_server_group_config.server_weight
  }

  servers {
    port              = var.alb_server_group_config.server_port
    server_id         = module.region3.ecs_private_ip
    server_ip         = module.region3.ecs_private_ip
    server_type       = var.alb_server_group_config.server_type
    remote_ip_enabled = var.alb_server_group_config.remote_ip_enabled
    weight            = var.alb_server_group_config.server_weight
  }
}

# ALB Listener
resource "alicloud_alb_listener" "alb_listener" {
  provider          = alicloud.region1
  load_balancer_id  = alicloud_alb_load_balancer.alb.id
  listener_protocol = var.alb_listener_config.listener_protocol
  listener_port     = var.alb_listener_config.listener_port

  default_actions {
    type = var.alb_listener_config.default_action_type

    forward_group_config {
      server_group_tuples {
        server_group_id = alicloud_alb_server_group.alb_rs.id
      }
    }
  }
}

# Transit Router Route Entries for ALB back-to-source routing
resource "alicloud_cen_transit_router_route_entry" "tr1_route_entry" {
  provider                                          = alicloud.region1
  for_each                                          = toset(var.alb_back_to_source_routing_cidrs)
  transit_router_route_table_id                     = module.region1.transit_router_route_table_id
  transit_router_route_entry_destination_cidr_block = each.key
  transit_router_route_entry_next_hop_type          = "Attachment"
  transit_router_route_entry_next_hop_id            = module.region1.vpc_attachment_id
}

# Transit Router Peer Attachments
resource "alicloud_cen_transit_router_peer_attachment" "peer12_attachment" {
  provider                            = alicloud.region1
  transit_router_peer_attachment_name = var.region2_network_config.peer_attachment_name
  cen_id                              = alicloud_cen_instance.cen.id
  transit_router_id                   = module.region1.transit_router_id
  peer_transit_router_region_id       = data.alicloud_regions.region2.regions[0].id
  peer_transit_router_id              = module.region2.transit_router_id
  auto_publish_route_enabled          = var.peer_attachment_auto_publish_route_enabled
}

resource "alicloud_cen_transit_router_peer_attachment" "peer13_attachment" {
  provider                            = alicloud.region1
  transit_router_peer_attachment_name = var.region3_network_config.peer_attachment_name
  cen_id                              = alicloud_cen_instance.cen.id
  transit_router_id                   = module.region1.transit_router_id
  peer_transit_router_region_id       = data.alicloud_regions.region3.regions[0].id
  peer_transit_router_id              = module.region3.transit_router_id
  auto_publish_route_enabled          = var.peer_attachment_auto_publish_route_enabled
}

# Peer Attachment Route Table Associations and Propagations
resource "alicloud_cen_transit_router_route_table_association" "tr1_association12" {
  provider                      = alicloud.region1
  transit_router_route_table_id = module.region1.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer12_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "tr1_propagation12" {
  provider                      = alicloud.region1
  transit_router_route_table_id = module.region1.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer12_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "tr1_association21" {
  provider                      = alicloud.region2
  transit_router_route_table_id = module.region2.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer12_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "tr1_propagation21" {
  provider                      = alicloud.region2
  transit_router_route_table_id = module.region2.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer12_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "tr1_association13" {
  provider                      = alicloud.region1
  transit_router_route_table_id = module.region1.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer13_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "tr1_propagation13" {
  provider                      = alicloud.region1
  transit_router_route_table_id = module.region1.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer13_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_association" "tr1_association31" {
  provider                      = alicloud.region3
  transit_router_route_table_id = module.region3.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer13_attachment.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "tr1_propagation31" {
  provider                      = alicloud.region3
  transit_router_route_table_id = module.region3.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_peer_attachment.peer13_attachment.transit_router_attachment_id
}

