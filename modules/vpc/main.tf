locals {
  vpc_name_prefix = var.vpc_name != null ? var.vpc_name : "vpc-${var.vpc_cidr}"
}

resource "alicloud_cen_transit_router" "tr" {
  transit_router_name = var.transit_router_name
  cen_id              = var.cen_id
}

resource "alicloud_vpc" "vpc" {
  vpc_name   = local.vpc_name_prefix
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "vsw" {
  count        = length(var.vswitch_configs)
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_configs[count.index].cidr_block
  zone_id      = var.vswitch_configs[count.index].zone_id
  vswitch_name = coalesce(var.vswitch_configs[count.index].vswitch_name, "${local.vpc_name_prefix}-vsw-${count.index + 1}")
}

# Security Group
resource "alicloud_security_group" "group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = coalesce(var.security_group_name, "${local.vpc_name_prefix}-sg")
  description         = var.security_group_description
}

# Security Group Rules
resource "alicloud_security_group_rule" "rules" {
  for_each = { for idx, rule in var.security_group_rules : idx => rule }

  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.group.id
  cidr_ip           = each.value.cidr_ip
}

# ECS Instance
resource "alicloud_instance" "ecs" {
  availability_zone    = var.vswitch_configs[0].zone_id
  security_groups      = [alicloud_security_group.group.id]
  instance_type        = var.ecs_instance_type
  system_disk_category = var.ecs_system_disk_type
  image_id             = var.ecs_image_id
  instance_name        = coalesce(var.ecs_name, "${local.vpc_name_prefix}-ecs")
  vswitch_id           = alicloud_vswitch.vsw[0].id
  password             = var.ecs_password
  user_data            = var.ecs_user_data
}

# VPC Attachment to Transit Router
resource "alicloud_cen_transit_router_vpc_attachment" "vpc_att" {
  cen_id            = var.cen_id
  transit_router_id = alicloud_cen_transit_router.tr.transit_router_id
  vpc_id            = alicloud_vpc.vpc.id

  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.vsw
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.id
    }
  }
}

# Transit Router Route Table
resource "alicloud_cen_transit_router_route_table" "tr_route_table" {
  transit_router_id = alicloud_cen_transit_router.tr.transit_router_id
}

# Route Table Association
resource "alicloud_cen_transit_router_route_table_association" "tr_table_association" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.tr_route_table.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.vpc_att.transit_router_attachment_id
}

# Route Table Propagation
resource "alicloud_cen_transit_router_route_table_propagation" "tr_table_propagation" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.tr_route_table.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.vpc_att.transit_router_attachment_id
}

# VPC Route Entries
resource "alicloud_route_entry" "vpc_route_entry" {
  for_each              = toset(var.vpc_route_cidrs)
  route_table_id        = alicloud_vpc.vpc.route_table_id
  destination_cidrblock = each.key
  nexthop_type          = "Attachment"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.vpc_att.transit_router_attachment_id
}
