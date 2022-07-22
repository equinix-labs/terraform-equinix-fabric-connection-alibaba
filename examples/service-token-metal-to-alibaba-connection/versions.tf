terraform {  
  required_version = ">= 0.13"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = ">= 1.7.0"
    }
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.165.0"
    }
  }
}
