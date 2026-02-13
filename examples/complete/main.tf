# Provider configurations for multiple regions
provider "alicloud" {
  alias  = "region1"
  region = var.region1
}

provider "alicloud" {
  alias  = "region2"
  region = var.region2
}

provider "alicloud" {
  alias  = "region3"
  region = var.region3
}

# Data sources to get available zones
data "alicloud_zones" "region1" {
  provider                    = alicloud.region1
  available_resource_creation = "VSwitch"
  available_instance_type     = data.alicloud_instance_types.region1.ids[0]
}

data "alicloud_zones" "region2" {
  provider                    = alicloud.region2
  available_resource_creation = "VSwitch"
  available_instance_type     = data.alicloud_instance_types.region2.ids[0]
}

data "alicloud_zones" "region3" {
  provider                    = alicloud.region3
  available_resource_creation = "VSwitch"
  # available_instance_type = data.alicloud_instance_types.region3.ids[0]
}

# Data sources for instance types
data "alicloud_instance_types" "region1" {
  provider             = alicloud.region1
  system_disk_category = var.system_disk_category
  instance_type_family = "ecs.c9i"
}

data "alicloud_instance_types" "region2" {
  provider             = alicloud.region2
  system_disk_category = var.system_disk_category
  instance_type_family = "ecs.c9i"
}

data "alicloud_instance_types" "region3" {
  provider             = alicloud.region3
  system_disk_category = var.system_disk_category
  instance_type_family = "ecs.c9i"
}

# Call the ALB cross-region load balancing module
module "alb_cross_region" {
  source = "../../"

  providers = {
    alicloud.region1 = alicloud.region1
    alicloud.region2 = alicloud.region2
    alicloud.region3 = alicloud.region3
  }

  # CEN configuration
  cen_config = {
    cen_instance_name = var.cen_instance_name
    description       = "CEN instance for ALB cross-region load balancing example"
  }

  # Region 1 configuration (ALB deployment region)
  region1_network_config = {
    transit_router_name = var.tr1_name
    vpc_name            = var.vpc1_name
    vpc_cidr            = var.vpc1_cidr
    vswitch_configs = [
      {
        zone_id      = data.alicloud_zones.region1.zones[0].id
        cidr_block   = var.vsw11_cidr
        vswitch_name = var.vsw11_name
      },
      {
        zone_id      = data.alicloud_zones.region1.zones[1].id
        cidr_block   = var.vsw12_cidr
        vswitch_name = var.vsw12_name
      }
    ]
    vpc_route_cidrs = toset([var.vpc1_cidr, var.vpc2_cidr, var.vpc3_cidr, var.vsw21_cidr, var.vsw31_cidr])
  }

  region1_security_group_config = {
    security_group_name        = var.group1_name
    security_group_description = "Security group for region 1"
    security_group_rules = [
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

  region1_ecs_config = {
    ecs_name             = var.ecs1_name
    ecs_instance_type    = data.alicloud_instance_types.region1.ids[0]
    ecs_image_id         = var.image_id
    ecs_password         = var.ecs_password
    ecs_system_disk_type = var.system_disk_category
  }

  # Region 2 configuration (Backend region)
  region2_network_config = {
    transit_router_name = var.tr2_name
    vpc_name            = var.vpc2_name
    vpc_cidr            = var.vpc2_cidr
    vswitch_configs = [
      {
        zone_id      = data.alicloud_zones.region2.zones[length(data.alicloud_zones.region2.zones) - 1].id
        cidr_block   = var.vsw21_cidr
        vswitch_name = var.vsw21_name
      },
      {
        zone_id      = data.alicloud_zones.region2.zones[length(data.alicloud_zones.region2.zones) - 2].id
        cidr_block   = var.vsw22_cidr
        vswitch_name = var.vsw22_name
      }
    ]
    vpc_route_cidrs      = concat([var.vpc1_cidr, var.vpc2_cidr, var.vpc3_cidr], var.alb_back_to_source_routing_cidrs)
    peer_attachment_name = var.peer12_name
  }

  region2_security_group_config = {
    security_group_name        = var.group2_name
    security_group_description = "Security group for region 2"
    security_group_rules = [
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

  region2_ecs_config = {
    ecs_name             = var.ecs2_name
    ecs_instance_type    = data.alicloud_instance_types.region2.ids[0]
    ecs_image_id         = var.image_id
    ecs_password         = var.ecs_password
    ecs_system_disk_type = var.system_disk_category
  }

  # Region 3 configuration (Backend region)
  region3_network_config = {
    transit_router_name = var.tr3_name
    vpc_name            = var.vpc3_name
    vpc_cidr            = var.vpc3_cidr
    vswitch_configs = [
      {
        zone_id      = data.alicloud_zones.region3.zones[0].id
        cidr_block   = var.vsw31_cidr
        vswitch_name = var.vsw31_name
      },
      {
        zone_id      = data.alicloud_zones.region3.zones[1].id
        cidr_block   = var.vsw32_cidr
        vswitch_name = var.vsw32_name
      }
    ]
    vpc_route_cidrs      = concat([var.vpc1_cidr, var.vpc2_cidr, var.vpc3_cidr], var.alb_back_to_source_routing_cidrs)
    peer_attachment_name = var.peer13_name
  }

  region3_security_group_config = {
    security_group_name        = var.group3_name
    security_group_description = "Security group for region 3"
    security_group_rules = [
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

  region3_ecs_config = {
    ecs_name             = var.ecs3_name
    ecs_instance_type    = data.alicloud_instance_types.region3.ids[0]
    ecs_image_id         = var.image_id
    ecs_password         = var.ecs_password
    ecs_system_disk_type = var.system_disk_category
  }

  # ALB configuration
  alb_config = {
    load_balancer_name = var.alb_name
  }

  # ALB Server Group configuration
  alb_server_group_config = {
    server_group_name = var.alb_server_group_name
  }
}
