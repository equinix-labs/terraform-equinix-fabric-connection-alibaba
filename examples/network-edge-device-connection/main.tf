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
  # 'region' and 'fabric_destination_metro_code' must correspond to same location
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
