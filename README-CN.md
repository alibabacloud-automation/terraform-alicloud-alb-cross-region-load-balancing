阿里云 ALB 跨地域负载均衡 Terraform 模块

# terraform-alicloud-alb-cross-region-load-balancing

[English](https://github.com/alibabacloud-automation/terraform-alicloud-alb-cross-region-load-balancing/blob/main/README.md) | 简体中文

用于实现解决方案[ALB 实现跨地域负载均衡](https://www.aliyun.com/solution/tech-solution/alb-acrlb)的 Terraform 模块，涉及到专有网络（VPC）、交换机（VSwitch）、云服务器（ECS）、云企业网（CEN）、应用型负载均衡（ALB）等资源的创建、配置和部署。

## 使用方法

该模块创建一个完整的 ALB 跨地域负载均衡架构，包含 CEN、转发路由器和分布在多个地域的后端 ECS 实例。ALB 通过 CEN 网络将流量分发到不同地域的后端服务器。

```terraform
provider "alicloud" {
  alias  = "region1"
  region = "cn-chengdu"
}

provider "alicloud" {
  alias  = "region2"
  region = "cn-shanghai"
}

provider "alicloud" {
  alias  = "region3"
  region = "cn-qingdao"
}

module "alb_cross_region" {
  source = "alibabacloud-automation/alb-cross-region-load-balancing/alicloud"

  providers = {
    alicloud.region1 = alicloud.region1
    alicloud.region2 = alicloud.region2
    alicloud.region3 = alicloud.region3
  }

  # CEN 配置
  cen_config = {
    cen_instance_name = "alb-cross-region-cen"
  }

  # 地域 1 网络配置（ALB 部署地域）
  region1_network_config = {
    vpc_cidr = "172.16.0.0/16"
    vswitch_configs = [
      {
        zone_id    = "cn-chengdu-a"
        cidr_block = "172.16.20.0/24"
      },
      {
        zone_id    = "cn-chengdu-b"
        cidr_block = "172.16.21.0/24"
      }
    ]
    vpc_route_cidrs = ["172.16.0.0/16", "10.0.0.0/16", "192.168.0.0/16"]
  }

  region1_security_group_config = {
    security_group_name = "sg-region1"
  }

  region1_ecs_config = {
    ecs_instance_type    = "ecs.c6.large"
    ecs_image_id         = "aliyun_3_x64_20G_alibase_20230727.vhd"
    ecs_password         = "YourPassword123!"
    ecs_system_disk_type = "cloud_essd"
  }

  # 地域 2 网络配置（后端地域）
  region2_network_config = {
    vpc_cidr = "10.0.0.0/16"
    vswitch_configs = [
      {
        zone_id    = "cn-shanghai-e"
        cidr_block = "10.0.20.0/24"
      },
      {
        zone_id    = "cn-shanghai-f"
        cidr_block = "10.0.21.0/24"
      }
    ]
    vpc_route_cidrs = ["172.16.0.0/16", "10.0.0.0/16", "192.168.0.0/16"]
  }

  region2_security_group_config = {
    security_group_name = "sg-region2"
  }

  region2_ecs_config = {
    ecs_instance_type    = "ecs.c6.large"
    ecs_image_id         = "aliyun_3_x64_20G_alibase_20230727.vhd"
    ecs_password         = "YourPassword123!"
    ecs_system_disk_type = "cloud_essd"
  }

  # 地域 3 网络配置（后端地域）
  region3_network_config = {
    vpc_cidr = "192.168.0.0/16"
    vswitch_configs = [
      {
        zone_id    = "cn-qingdao-c"
        cidr_block = "192.168.20.0/24"
      },
      {
        zone_id    = "cn-qingdao-b"
        cidr_block = "192.168.21.0/24"
      }
    ]
    vpc_route_cidrs = ["172.16.0.0/16", "10.0.0.0/16", "192.168.0.0/16"]
  }

  region3_security_group_config = {
    security_group_name = "sg-region3"
  }

  region3_ecs_config = {
    ecs_instance_type    = "ecs.c6.large"
    ecs_image_id         = "aliyun_3_x64_20G_alibase_20230727.vhd"
    ecs_password         = "YourPassword123!"
    ecs_system_disk_type = "cloud_essd"
  }

  # ALB 配置
  alb_config = {
    load_balancer_name = "alb-cross-region"
  }

  # ALB 服务器组配置
  alb_server_group_config = {
    server_group_name = "alb-server-group"
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-alb-cross-region-load-balancing/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |
| <a name="provider_alicloud.region1"></a> [alicloud.region1](#provider\_alicloud.region1) | n/a |
| <a name="provider_alicloud.region2"></a> [alicloud.region2](#provider\_alicloud.region2) | n/a |
| <a name="provider_alicloud.region3"></a> [alicloud.region3](#provider\_alicloud.region3) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_region1"></a> [region1](#module\_region1) | ./modules/vpc | n/a |
| <a name="module_region2"></a> [region2](#module\_region2) | ./modules/vpc | n/a |
| <a name="module_region3"></a> [region3](#module\_region3) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_alb_listener.alb_listener](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_listener) | resource |
| [alicloud_alb_load_balancer.alb](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_load_balancer) | resource |
| [alicloud_alb_server_group.alb_rs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/alb_server_group) | resource |
| [alicloud_cen_instance.cen](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_transit_router_peer_attachment.peer12_attachment](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_peer_attachment) | resource |
| [alicloud_cen_transit_router_peer_attachment.peer13_attachment](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_peer_attachment) | resource |
| [alicloud_cen_transit_router_route_entry.tr1_route_entry](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_entry) | resource |
| [alicloud_cen_transit_router_route_table_association.tr1_association12](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.tr1_association13](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.tr1_association21](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.tr1_association31](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr1_propagation12](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr1_propagation13](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr1_propagation21](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_route_table_propagation.tr1_propagation31](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_service.open](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/cen_transit_router_service) | data source |
| [alicloud_regions.region2](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |
| [alicloud_regions.region3](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_back_to_source_routing_cidrs"></a> [alb\_back\_to\_source\_routing\_cidrs](#input\_alb\_back\_to\_source\_routing\_cidrs) | List of CIDR blocks for ALB back-to-source routing. | `list(string)` | <pre>[<br/>  "100.117.130.0/25",<br/>  "100.117.130.128/25",<br/>  "100.117.131.0/25",<br/>  "100.117.131.128/25",<br/>  "100.122.175.64/26",<br/>  "100.122.175.128/26",<br/>  "100.122.175.192/26",<br/>  "100.122.176.0/26"<br/>]</pre> | no |
| <a name="input_alb_config"></a> [alb\_config](#input\_alb\_config) | The parameters of ALB load balancer. The attributes 'load\_balancer\_name' is required. | <pre>object({<br/>    address_type           = optional(string, "Intranet")<br/>    address_allocated_mode = optional(string, "Fixed")<br/>    load_balancer_name     = string<br/>    load_balancer_edition  = optional(string, "Basic")<br/>    pay_type               = optional(string, "PayAsYouGo")<br/>  })</pre> | <pre>{<br/>  "load_balancer_name": null<br/>}</pre> | no |
| <a name="input_alb_listener_config"></a> [alb\_listener\_config](#input\_alb\_listener\_config) | The parameters of ALB listener. | <pre>object({<br/>    listener_protocol   = optional(string, "HTTP")<br/>    listener_port       = optional(number, 80)<br/>    default_action_type = optional(string, "ForwardGroup")<br/>  })</pre> | `{}` | no |
| <a name="input_alb_server_group_config"></a> [alb\_server\_group\_config](#input\_alb\_server\_group\_config) | The parameters of ALB server group. The attribute 'server\_group\_name' is required. | <pre>object({<br/>    protocol               = optional(string, "HTTP")<br/>    server_group_name      = string<br/>    server_group_type      = optional(string, "Ip")<br/>    health_check_enabled   = optional(bool, false)<br/>    sticky_session_enabled = optional(bool, false)<br/>    server_port            = optional(number, 80)<br/>    server_type            = optional(string, "Ip")<br/>    remote_ip_enabled      = optional(bool, true)<br/>    server_weight          = optional(number, 100)<br/>  })</pre> | <pre>{<br/>  "server_group_name": null<br/>}</pre> | no |
| <a name="input_cen_config"></a> [cen\_config](#input\_cen\_config) | The parameters of CEN instance. The attribute 'cen\_instance\_name' is required. | <pre>object({<br/>    cen_instance_name = string<br/>    description       = optional(string, "CEN instance for cross-region load balancing")<br/>  })</pre> | <pre>{<br/>  "cen_instance_name": null<br/>}</pre> | no |
| <a name="input_peer_attachment_auto_publish_route_enabled"></a> [peer\_attachment\_auto\_publish\_route\_enabled](#input\_peer\_attachment\_auto\_publish\_route\_enabled) | Whether to enable auto publish route for transit router peer attachments. | `bool` | `true` | no |
| <a name="input_region1_ecs_config"></a> [region1\_ecs\_config](#input\_region1\_ecs\_config) | ECS instance configuration for Region 1. | <pre>object({<br/>    ecs_name             = optional(string, "ECS1")<br/>    ecs_instance_type    = string<br/>    ecs_image_id         = string<br/>    ecs_password         = string<br/>    ecs_system_disk_type = string<br/>    ecs_user_data        = optional(string, "#!/bin/sh\necho \"Hello World ! This is ECS01.\" > index.html\nnohup python3 -m http.server 80 &")<br/>  })</pre> | n/a | yes |
| <a name="input_region1_network_config"></a> [region1\_network\_config](#input\_region1\_network\_config) | Network configuration for Region 1 (ALB deployment region). Includes Transit Router, VPC, VSwitches, and routing. | <pre>object({<br/>    # Transit Router<br/>    transit_router_name = optional(string, "tr-alb-region")<br/>    # VPC<br/>    vpc_name = optional(string, "vpc-alb-region")<br/>    vpc_cidr = string<br/>    # VSwitches<br/>    vswitch_configs = list(object({<br/>      zone_id      = string<br/>      cidr_block   = string<br/>      vswitch_name = optional(string, "vsw-alb")<br/>    }))<br/>    # VPC Route CIDRs<br/>    vpc_route_cidrs = list(string)<br/>  })</pre> | n/a | yes |
| <a name="input_region1_security_group_config"></a> [region1\_security\_group\_config](#input\_region1\_security\_group\_config) | Security group configuration for Region 1. | <pre>object({<br/>    security_group_name        = string<br/>    security_group_description = optional(string, "Security group for ALB cross-region load balancing")<br/>    # Security Group Rules<br/>    security_group_rules = optional(list(object({<br/>      type        = optional(string, "ingress")<br/>      ip_protocol = optional(string, "all")<br/>      nic_type    = optional(string, "intranet")<br/>      policy      = optional(string, "accept")<br/>      port_range  = optional(string, "-1/-1")<br/>      priority    = optional(number, 1)<br/>      cidr_ip     = optional(string, "0.0.0.0/0")<br/>      })), [<br/>      {<br/>        type        = "ingress"<br/>        ip_protocol = "all"<br/>        nic_type    = "intranet"<br/>        policy      = "accept"<br/>        port_range  = "-1/-1"<br/>        priority    = 1<br/>        cidr_ip     = "0.0.0.0/0"<br/>      }<br/>    ])<br/>  })</pre> | n/a | yes |
| <a name="input_region2_ecs_config"></a> [region2\_ecs\_config](#input\_region2\_ecs\_config) | ECS instance configuration for Region 2. | <pre>object({<br/>    ecs_name             = optional(string, "ECS2")<br/>    ecs_instance_type    = string<br/>    ecs_image_id         = string<br/>    ecs_password         = string<br/>    ecs_system_disk_type = string<br/>    ecs_user_data        = optional(string, "#!/bin/sh\necho \"Hello World ! This is ECS02.\" > index.html\nnohup python3 -m http.server 80 &")<br/>  })</pre> | n/a | yes |
| <a name="input_region2_network_config"></a> [region2\_network\_config](#input\_region2\_network\_config) | Network configuration for Region 2 (Backend region). Includes Transit Router, VPC, VSwitches, and routing. | <pre>object({<br/>    # Transit Router<br/>    transit_router_name = optional(string, "tr-backend-region2")<br/>    # VPC<br/>    vpc_name = optional(string, "vpc-backend-region2")<br/>    vpc_cidr = string<br/>    # VSwitches<br/>    vswitch_configs = list(object({<br/>      zone_id      = string<br/>      cidr_block   = string<br/>      vswitch_name = optional(string, "vsw-backend")<br/>    }))<br/>    # VPC Route CIDRs<br/>    vpc_route_cidrs = list(string)<br/>    # Peer Attachment Name<br/>    peer_attachment_name = optional(string, "peer-alb-to-backend2")<br/>  })</pre> | n/a | yes |
| <a name="input_region2_security_group_config"></a> [region2\_security\_group\_config](#input\_region2\_security\_group\_config) | Security group configuration for Region 2. | <pre>object({<br/>    security_group_name        = string<br/>    security_group_description = optional(string, "Security group for ALB cross-region load balancing")<br/>    # Security Group Rules<br/>    security_group_rules = optional(list(object({<br/>      type        = optional(string, "ingress")<br/>      ip_protocol = optional(string, "all")<br/>      nic_type    = optional(string, "intranet")<br/>      policy      = optional(string, "accept")<br/>      port_range  = optional(string, "-1/-1")<br/>      priority    = optional(number, 1)<br/>      cidr_ip     = optional(string, "0.0.0.0/0")<br/>      })), [<br/>      {<br/>        type        = "ingress"<br/>        ip_protocol = "all"<br/>        nic_type    = "intranet"<br/>        policy      = "accept"<br/>        port_range  = "-1/-1"<br/>        priority    = 1<br/>        cidr_ip     = "0.0.0.0/0"<br/>      }<br/>    ])<br/>  })</pre> | n/a | yes |
| <a name="input_region3_ecs_config"></a> [region3\_ecs\_config](#input\_region3\_ecs\_config) | ECS instance configuration for Region 3. | <pre>object({<br/>    ecs_name             = optional(string, "ECS3")<br/>    ecs_instance_type    = string<br/>    ecs_image_id         = string<br/>    ecs_password         = string<br/>    ecs_system_disk_type = string<br/>    ecs_user_data        = optional(string, "#!/bin/sh\necho \"Hello World ! This is ECS03.\" > index.html\nnohup python3 -m http.server 80 &")<br/>  })</pre> | n/a | yes |
| <a name="input_region3_network_config"></a> [region3\_network\_config](#input\_region3\_network\_config) | Network configuration for Region 3 (Backend region). Includes Transit Router, VPC, VSwitches, and routing. | <pre>object({<br/>    # Transit Router<br/>    transit_router_name = optional(string, "tr-backend-region3")<br/>    # VPC<br/>    vpc_name = optional(string, "vpc-backend-region3")<br/>    vpc_cidr = string<br/>    # VSwitches<br/>    vswitch_configs = list(object({<br/>      zone_id      = string<br/>      cidr_block   = string<br/>      vswitch_name = optional(string, "vsw-backend")<br/>    }))<br/>    # VPC Route CIDRs<br/>    vpc_route_cidrs = list(string)<br/>    # Peer Attachment Name<br/>    peer_attachment_name = optional(string, "peer-alb-to-backend3")<br/>  })</pre> | n/a | yes |
| <a name="input_region3_security_group_config"></a> [region3\_security\_group\_config](#input\_region3\_security\_group\_config) | Security group configuration for Region 3. | <pre>object({<br/>    security_group_name        = string<br/>    security_group_description = optional(string, "Security group for ALB cross-region load balancing")<br/>    # Security Group Rules<br/>    security_group_rules = optional(list(object({<br/>      type        = optional(string, "ingress")<br/>      ip_protocol = optional(string, "all")<br/>      nic_type    = optional(string, "intranet")<br/>      policy      = optional(string, "accept")<br/>      port_range  = optional(string, "-1/-1")<br/>      priority    = optional(number, 1)<br/>      cidr_ip     = optional(string, "0.0.0.0/0")<br/>      })), [<br/>      {<br/>        type        = "ingress"<br/>        ip_protocol = "all"<br/>        nic_type    = "intranet"<br/>        policy      = "accept"<br/>        port_range  = "-1/-1"<br/>        priority    = 1<br/>        cidr_ip     = "0.0.0.0/0"<br/>      }<br/>    ])<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb\_dns\_name](#output\_alb\_dns\_name) | The DNS name of the ALB load balancer |
| <a name="output_alb_listener_id"></a> [alb\_listener\_id](#output\_alb\_listener\_id) | The ID of the ALB listener |
| <a name="output_alb_load_balancer_id"></a> [alb\_load\_balancer\_id](#output\_alb\_load\_balancer\_id) | The ID of the ALB load balancer |
| <a name="output_alb_server_group_id"></a> [alb\_server\_group\_id](#output\_alb\_server\_group\_id) | The ID of the ALB server group |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The ID of the CEN instance |
| <a name="output_ecs1_id"></a> [ecs1\_id](#output\_ecs1\_id) | The ID of ECS instance in region1 |
| <a name="output_ecs1_private_ip"></a> [ecs1\_private\_ip](#output\_ecs1\_private\_ip) | The private IP address of ECS instance in region1 |
| <a name="output_ecs2_id"></a> [ecs2\_id](#output\_ecs2\_id) | The ID of ECS instance in region2 |
| <a name="output_ecs2_private_ip"></a> [ecs2\_private\_ip](#output\_ecs2\_private\_ip) | The private IP address of ECS instance in region2 |
| <a name="output_ecs3_id"></a> [ecs3\_id](#output\_ecs3\_id) | The ID of ECS instance in region3 |
| <a name="output_ecs3_private_ip"></a> [ecs3\_private\_ip](#output\_ecs3\_private\_ip) | The private IP address of ECS instance in region3 |
| <a name="output_peer12_attachment_id"></a> [peer12\_attachment\_id](#output\_peer12\_attachment\_id) | The ID of peer attachment between transit router 1 and 2 |
| <a name="output_peer13_attachment_id"></a> [peer13\_attachment\_id](#output\_peer13\_attachment\_id) | The ID of peer attachment between transit router 1 and 3 |
| <a name="output_security_group1_id"></a> [security\_group1\_id](#output\_security\_group1\_id) | The ID of security group in region1 |
| <a name="output_security_group2_id"></a> [security\_group2\_id](#output\_security\_group2\_id) | The ID of security group in region2 |
| <a name="output_security_group3_id"></a> [security\_group3\_id](#output\_security\_group3\_id) | The ID of security group in region3 |
| <a name="output_tr1_route_table_id"></a> [tr1\_route\_table\_id](#output\_tr1\_route\_table\_id) | The ID of transit router route table in region1 |
| <a name="output_tr2_route_table_id"></a> [tr2\_route\_table\_id](#output\_tr2\_route\_table\_id) | The ID of transit router route table in region2 |
| <a name="output_tr3_route_table_id"></a> [tr3\_route\_table\_id](#output\_tr3\_route\_table\_id) | The ID of transit router route table in region3 |
| <a name="output_transit_router_tr1_id"></a> [transit\_router\_tr1\_id](#output\_transit\_router\_tr1\_id) | The ID of the transit router in region1 |
| <a name="output_transit_router_tr2_id"></a> [transit\_router\_tr2\_id](#output\_transit\_router\_tr2\_id) | The ID of the transit router in region2 |
| <a name="output_transit_router_tr3_id"></a> [transit\_router\_tr3\_id](#output\_transit\_router\_tr3\_id) | The ID of the transit router in region3 |
| <a name="output_vpc1_id"></a> [vpc1\_id](#output\_vpc1\_id) | The ID of VPC in region1 |
| <a name="output_vpc1_route_table_id"></a> [vpc1\_route\_table\_id](#output\_vpc1\_route\_table\_id) | The route table ID of VPC in region1 |
| <a name="output_vpc2_id"></a> [vpc2\_id](#output\_vpc2\_id) | The ID of VPC in region2 |
| <a name="output_vpc2_route_table_id"></a> [vpc2\_route\_table\_id](#output\_vpc2\_route\_table\_id) | The route table ID of VPC in region2 |
| <a name="output_vpc3_id"></a> [vpc3\_id](#output\_vpc3\_id) | The ID of VPC in region3 |
| <a name="output_vpc3_route_table_id"></a> [vpc3\_route\_table\_id](#output\_vpc3\_route\_table\_id) | The route table ID of VPC in region3 |
| <a name="output_vpc_attachment1_id"></a> [vpc\_attachment1\_id](#output\_vpc\_attachment1\_id) | The ID of VPC attachment to transit router in region1 |
| <a name="output_vpc_attachment2_id"></a> [vpc\_attachment2\_id](#output\_vpc\_attachment2\_id) | The ID of VPC attachment to transit router in region2 |
| <a name="output_vpc_attachment3_id"></a> [vpc\_attachment3\_id](#output\_vpc\_attachment3\_id) | The ID of VPC attachment to transit router in region3 |
| <a name="output_vsw11_id"></a> [vsw11\_id](#output\_vsw11\_id) | The ID of VSwitch 11 in region1 |
| <a name="output_vsw12_id"></a> [vsw12\_id](#output\_vsw12\_id) | The ID of VSwitch 12 in region1 |
| <a name="output_vsw21_id"></a> [vsw21\_id](#output\_vsw21\_id) | The ID of VSwitch 21 in region2 |
| <a name="output_vsw22_id"></a> [vsw22\_id](#output\_vsw22\_id) | The ID of VSwitch 22 in region2 |
| <a name="output_vsw31_id"></a> [vsw31\_id](#output\_vsw31\_id) | The ID of VSwitch 31 in region3 |
| <a name="output_vsw32_id"></a> [vsw32\_id](#output\_vsw32\_id) | The ID of VSwitch 32 in region3 |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)