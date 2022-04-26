provider "equinix" {}

provider "alicloud" {
  region = "eu-central-1"
}

module "equinix-fabric-connection-alibaba" {
  # source = "equinix-labs/fabric-connection-alibaba/equinix"
  source = "../../"

  # required variables
  fabric_notification_users = ["example@equinix.com"]
  alicloud_account_id       = var.alicloud_account_id
  
  # optional variables
  fabric_port_name              = var.port_name
  fabric_vlan_stag              = 1010
  fabric_destination_metro_code = "FR"
}
