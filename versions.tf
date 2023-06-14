terraform {
  required_version = ">= 0.13"

  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "~> 1.14"
    }
    alicloud = {
      source  = "aliyun/alicloud"
      version = ">= 1.165.0"
    }
  }
  provider_meta "equinix" {
    module_name = "equinix-fabric-connection-alibaba"
  }
}
