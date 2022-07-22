# Configure the Equinix Provider
# Please refer to provider documentation for details on supported authentication methods and parameters.
# https://registry.terraform.io/providers/equinix/equinix/latest/docs
provider "equinix" {
  client_id     = var.equinix_provider_client_id
  client_secret = var.equinix_provider_client_secret
}

# Configure the Alibaba Provider
# https://registry.terraform.io/providers/aliyun/alicloud/latest/docs#authentication
provider "alicloud" { 
  region = var.alicloud_region
}

## Retrieve an existing equinix metal project
## If you prefer you can use resource equinix_metal_project instead to create a fresh project
data "equinix_metal_project" "this" {
  project_id = var.metal_project_id
}

locals {
  connection_name = format("conn-metal-alibaba-%s", lower(var.fabric_destination_metro_code))
}

# Create a new VLAN in Frankfurt
resource "equinix_metal_vlan" "this" {
  description = format("VLAN in %s", var.fabric_destination_metro_code)
  metro       = var.fabric_destination_metro_code
  project_id  = data.equinix_metal_project.this.project_id
}

## Request a connection service token in Equinix Metal
resource "equinix_metal_connection" "this" {
    name               = local.connection_name
    project_id         = data.equinix_metal_project.this.project_id
    metro              = var.fabric_destination_metro_code
    redundancy         = "primary"
    type               = "shared"
    service_token_type = "a_side"
    description        = format("connection to Alibaba in %s", var.fabric_destination_metro_code)
    speed              = format("%dMbps", var.fabric_speed)
    vlans              = [equinix_metal_vlan.this.vxlan]
}

## Configure the Equinix Fabric connection from Equinix Metal to Alibaba using the metal connection service token
module "equinix-fabric-connection-alibaba-primary" {
  source = "equinix-labs/fabric-connection-alibaba/equinix"
  
  fabric_notification_users         = var.fabric_notification_users
  fabric_connection_name            = local.connection_name
  fabric_destination_metro_code     = var.fabric_destination_metro_code
  fabric_speed                      = var.fabric_speed
  fabric_service_token_id           = equinix_metal_connection.this.service_tokens.0.id
  
  alicloud_account_id = var.alicloud_account_id
  
  # alicloud_configure_bgp = true // If unspecified, default value is true
  # alicloud_express_connect_bgp_customer_peer_ip = "10.0.0.17/30" // If unspecified, default value "10.0.0.17/30" will be used
  # alicloud_express_connect_bgp_cloud_peer_ip    = "10.0.0.18" // If unspecified, default value  "10.0.0.18" will be used
  # alicloud_express_connect_bgp_customer_asn     = "65000" // If unspecified, default value "65000" will be used
  alicloud_express_connect_bgp_auth_key         = random_password.this.result
}

## Optionally we use an auto-generated password to enable authentication (shared key) between the two BGP peers
resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "$%&*()-_=+[]{}<>:?"
}
