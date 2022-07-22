## Equinix Fabric L2 Connection To Alibaba Express Connect Terraform module

[![Experimental](https://img.shields.io/badge/Stability-Experimental-red.svg)](https://github.com/equinix-labs/standards#about-uniform-standards)
[![terraform](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml/badge.svg)](https://github.com/equinix-labs/terraform-equinix-template/actions/workflows/integration.yaml)

`terraform-equinix-fabric-connection-alibaba` is a Terraform module that utilizes [Terraform provider for Equinix](https://registry.terraform.io/providers/equinix/equinix/latest) and [Terraform provider for Alibaba](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs) to set up an Equinix Fabric L2 connection to Alibaba Express Connect.

As part of Platform Equinix, your infrastructure can connect with other parties, such as public cloud providers, network service providers, or your own colocation cages in Equinix by defining an [Equinix Fabric - software-defined interconnection](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/Fabric-landing-main.htm).

This module creates the l2 connection in Equinix Fabric, approves the request in your account on the Alibaba platform, and optionally creates a Alibaba Express Connect private virtual interface (VIF) and a virtual private gateway (VGW). BGP in Equinix side can be optionally configured if Network Edge device is used.

```html
     Origin                                              Destination
    (A-side)                                              (Z-side)

┌────────────────┐
│ Equinix Fabric │         Equinix Fabric          ┌────────────────────┐       ┌─────────────────────┐
│ Port / Network ├─────    l2 connection   ───────►│      Alibaba       │──────►│  VBR ─► BGP Group   │
│ Edge Device /  │      (50 Mbps - 10 Gbps)        │   Express Connect  │       │     ─► BGP Peer     │
│ Service Token  │                                 └────────────────────┘       │   (Alibaba Region)  │
└────────────────┘                                                              └─────────────────────┘
         │                                                                           │
         └ - - - - - - - - - - Network Edge Device - - - - - - - - - - - - - - - - - ┘
                                   BGP peering
```

### Usage

This project is experimental and supported by the user community. Equinix does not provide support for this project.

Install Terraform using the official guides at <https://learn.hashicorp.com/tutorials/terraform/install-cli>.

This project may be forked, cloned, or downloaded and modified as needed as the base in your integrations and deployments.

This project may also be used as a [Terraform module](https://learn.hashicorp.com/collections/terraform/modules).

To use this module in a new project, create a file such as:

```hcl
# main.tf
provider "equinix" {}

provider "alibaba" { region = "eu-central-1" }

data "alibaba_region" "this" {}

module "equinix-fabric-connection-alibaba" {
  source  = "equinix-labs/fabric-connection-alibaba/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  alicloud_account_id            = var.alibaba_account_id

  # optional variables
  fabric_destination_metro_code = "FR"
  network_edge_device_id        = "DeviceID"
}

```

Run `terraform init -upgrade` and `terraform apply`.

### Variables

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-alibaba/equinix/latest?tab=inputs> for a description of all variables.

### Outputs

See <https://registry.terraform.io/modules/equinix-labs/fabric-connection-alibaba/equinix/latest?tab=outputs> for a description of all outputs.

### Resources

| Name | Type |
|------|------|
| [random_string.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [equinix-fabric-connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection/equinix/latest) | module |
| [equinix_network_bgp.this](https://registry.terraform.io/providers/equinix/equinix/latest/docs/resources/equinix_network_bgp) | resource |
| [alicloud_regions.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |
| [alicloud_express_connect_virtual_border_routers.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/express_connect_virtual_border_routers) | data source |
| [alicloud_vpc_bgp_group.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc_bgp_group) | resource |
| [alicloud_vpc_bgp_peer.this](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc_bgp_peer) | resource |
| [external.os](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source) | data source |
| [null_resource.confirm_express_connect_virtual_border_router_creation](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |

### Examples

- [Fabric Port connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection-alibaba/equinix/latest/examples/fabric-port-connection/)
- [Network Edge device connection](https://registry.terraform.io/modules/equinix-labs/fabric-connection-alibaba/equinix/latest/examples/network-edge-device-connection/)
- [Service Token (a-side) Equinix Metal to Alibaba redundant connection End-to-End Solution](https://registry.terraform.io/modules/equinix-labs/fabric-connection-alibaba/equinix/latest/examples/service-token-metal-to-alibaba-connection/)
