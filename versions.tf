terraform {
  required_version = ">= 1.0"
  required_providers {
    alicloud = {
      source                = "aliyun/alicloud"
      configuration_aliases = [alicloud.region1, alicloud.region2, alicloud.region3]
    }
  }
}