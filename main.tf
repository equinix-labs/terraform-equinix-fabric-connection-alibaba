data "alicloud_regions" "this" {
  current = true
}

resource "random_string" "this" {
  length  = 3
  special = false
  upper   = false
}

module "equinix-fabric-connection" {
  source  = "equinix-labs/fabric-connection/equinix"
  version = "0.4.0"

  # required variables
  notification_users = var.fabric_notification_users

  # optional variables
  name = var.fabric_connection_name

  seller_profile_name      = "Alibaba Cloud Express Connect"
  seller_metro_code        = var.fabric_destination_metro_code
  seller_metro_name        = var.fabric_destination_metro_name
  seller_region            = local.alicloud_region
  seller_authorization_key = var.alicloud_account_id

  network_edge_id           = var.network_edge_device_id
  network_edge_interface_id = var.network_edge_device_interface_id
  port_name                 = var.fabric_port_name
  vlan_stag                 = var.fabric_vlan_stag
  service_token_id          = var.fabric_service_token_id
  speed                     = var.fabric_speed
  speed_unit                = "MB"
  purchase_order_number     = var.fabric_purchase_order_number
}

data "alicloud_express_connect_virtual_border_routers" "this" {

  depends_on = [
    module.equinix-fabric-connection.primary_connection
  ]
  //TODO zside_port_name is not being returned from the provider
  # filter {
  #   key    = "PhysicalConnectionId"
  #   values = [module.equinix-fabric-connection.primary_connection.zside_port_name]
  # }
  filter {
    key    = "Status"
    values = ["unconfirmed", "active"]
  }
}

//Resource implementation to accept the connection on Alibaba side 
resource "null_resource" "confirm_express_connect_virtual_border_router_creation" {

  depends_on = [
    data.alicloud_express_connect_virtual_border_routers.this
  ]

  triggers = {
    vbr_id = local.vbr_id
  }

  provisioner "local-exec" {
    working_dir = "${path.module}/bin/${local.os}"
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : ["/bin/bash", "-c"]

    command = "./alibaba-manage-vbr confirm-creation --access-key=$ACCESS_KEY --secret-key=$SECRET_KEY --region=$REGION --vbr-id=$VBR_ID --cloud-ip=$CLOUD_IP --customer-ip=$CUSTOMER_IP --subnet-mask=$SUBNET_MASK"
    environment = {
      ACCESS_KEY  = var.alicloud_access_key
      SECRET_KEY  = var.alicloud_secret_key
      REGION      = local.alicloud_region
      CLOUD_IP    = var.alicloud_express_connect_bgp_cloud_peer_ip
      CUSTOMER_IP = split("/", var.alicloud_express_connect_bgp_customer_peer_ip)[0]
      SUBNET_MASK = cidrnetmask(var.alicloud_express_connect_bgp_customer_peer_ip)
      VBR_ID      = local.vbr_id
    }
  }
}

resource "alicloud_vpc_bgp_group" "this" {
  count = var.alicloud_configure_bgp ? 1 : 0

  depends_on = [
    data.alicloud_express_connect_virtual_border_routers.this
  ]

  auth_key       = var.alicloud_express_connect_bgp_auth_key != "" ? var.alicloud_express_connect_bgp_auth_key : null
  bgp_group_name = format("bgp-group-%s", random_string.this.result)
  description    = "BGP group to connect with Equinix Fabric"
  peer_asn       = var.alicloud_express_connect_bgp_customer_asn
  router_id      = local.vbr_id
}

resource "alicloud_vpc_bgp_peer" "this" {
  count = var.alicloud_configure_bgp ? 1 : 0

  enable_bfd      = false
  bgp_group_id    = alicloud_vpc_bgp_group.this[0].id
  ip_version      = "IPV4"
  peer_ip_address = split("/", var.alicloud_express_connect_bgp_customer_peer_ip)[0]
}

resource "equinix_network_bgp" "this" {
  count = alltrue([var.alicloud_configure_bgp, var.network_edge_device_id != "", var.network_edge_configure_bgp]) ? 1 : 0

  connection_id      = module.equinix-fabric-connection.primary_connection.uuid
  local_ip_address   = var.alicloud_express_connect_bgp_customer_peer_ip
  local_asn          = var.alicloud_express_connect_bgp_customer_asn
  remote_ip_address  = var.alicloud_express_connect_bgp_cloud_peer_ip
  remote_asn         = alicloud_vpc_bgp_group.this[0].local_asn
  authentication_key = alicloud_vpc_bgp_group.this[0].auth_key != "" ? alicloud_vpc_bgp_group.this[0].auth_key : null
}

locals {
  vbr_id = [
    for router in data.alicloud_express_connect_virtual_border_routers.this.routers : router.id
    if router.vlan_id == module.equinix-fabric-connection.primary_connection.zside_vlan_stag
  ][0]

  vbr_route_table_id = [
    for router in data.alicloud_express_connect_virtual_border_routers.this.routers : router.route_table_id
    if router.vlan_id == module.equinix-fabric-connection.primary_connection.zside_vlan_stag
  ][0]

  alicloud_region = coalesce(var.alicloud_region, data.alicloud_regions.this.regions.0.id)
  is_windows      = substr(pathexpand("~"), 0, 1) == "/" ? false : true // if directories use "/" for root then OS linux based, otherwise set windows
  os              = data.external.os.result.os
}

data "external" "os" {
  working_dir = "${path.module}/scripts/"
  program     = local.is_windows ? ["{\"os\": \"win\"}"] : ["/bin/bash", "check_linux_os.sh"]
}
