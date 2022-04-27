provider "equinix" {}

provider "alicloud" {
  region = "eu-central-1"
}

module "equinix-fabric-connection-alibaba" {
  source = "equinix-labs/fabric-connection-alibaba/equinix"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  alicloud_account_id       = var.alicloud_account_id

  # optional variables
  network_edge_device_id     = var.device_id
  network_edge_configure_bgp = true

  fabric_destination_metro_code = "FR"
  fabric_speed                  = 200

  alicloud_express_connect_bgp_customer_peer_ip = "169.0.0.1/30"
  alicloud_express_connect_bgp_cloud_peer_ip    = "169.0.0.2"
  alicloud_express_connect_bgp_customer_asn     = 65432
  alicloud_express_connect_bgp_auth_key         = "MyBGPSecret"
}
