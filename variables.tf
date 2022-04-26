variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."

  validation {
    condition     = length(var.fabric_notification_users) > 0
    error_message = "Notification list cannot be empty."
  }
}

variable "fabric_connection_name" {
  type        = string
  description = "Name of the connection resource that will be created. It will be auto-generated if not specified."
  default     = ""
}

variable "fabric_destination_metro_code" {
  type        = string
  description = <<EOF
  Destination Metro code where the connection will be created. If you do not know the code, 'fabric_destination_metro_name'
  can be use instead.
  EOF
  default     = ""

  validation {
    condition = ( 
      var.fabric_destination_metro_code == "" ? true : can(regex("^[A-Z]{2}$", var.fabric_destination_metro_code))
    )
    error_message = "Valid metro code consits of two capital leters, i.e. 'FR', 'SV', 'DC'."
  }
}

variable "fabric_destination_metro_name" {
  type        = string
  description = <<EOF
  Only required in the absence of 'fabric_destination_metro_code'. Metro name where the connection will be created,
  i.e. 'Frankfurt', 'Silicon Valley', 'Ashburn'. One of 'fabric_destination_metro_code', 'fabric_destination_metro_name'
  must be provided.
  EOF
  default     = ""
}

variable "network_edge_device_id" {
  type        = string
  description = "Unique identifier of the Network Edge virtual device from which the connection would originate."
  default     = ""
}

variable "network_edge_device_interface_id" {
  type        = number
  description = <<EOF
  Applicable with 'network_edge_device_id', identifier of network interface on a given device, used for a connection.
  If not specified then first available interface will be selected.
  EOF
  default     = 0
}

variable "network_edge_configure_bgp" {
  type        = bool
  description = <<EOF
  Applicable with 'network_edge_device_id' and 'alicloud_configure_bgp'. Creation and management of Equinix Network Edge BGP
  peering configurations. It requires that 'alicloud_configure_bgp' is set to true.
  EOF
  default     = false
}

variable "fabric_port_name" {
  type        = string
  description = <<EOF
  Name of the buyer's port from which the connection would originate. One of 'fabric_port_name',
  'network_edge_device_id' or 'fabric_service_token_id' is required.
  EOF
  default     = ""
}

variable "fabric_vlan_stag" {
  type        = number
  description = <<EOF
  S-Tag/Outer-Tag of the primary connection - a numeric character ranging from 2 - 4094. Required if 'port_name' is
  specified.
  EOF
  default     = 0
}

variable "fabric_service_token_id" {
  type        = string
  description = <<EOF
  Unique Equinix Fabric key shared with you by a provider that grants you authorization to use their interconnection
  asset from which the connection would originate.
  EOF
  default     = ""
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If not specified, it will be used the minimum bandwidth
  available for the Alibaba service profile.
  EOF
  default     = 0

  validation {
    condition = contains([0, 50, 200, 500, 1000], var.fabric_speed)
    error_message = "Valid values are (0, 50, 200, 500, 1000)."
  }
}

variable "fabric_purcharse_order_number" {
  type        = string
  description = "Connection's purchase order number to reflect on the invoice."
  default     = ""
}

variable alicloud_region {
  type        = string
  description = <<EOF
  The name of the region to select, such as eu-central-1. Required if the region is not
  configured in the provider.
  EOF
  default = ""
}

variable "alicloud_account_id" {
  type        = string
  description = "Your Alibaba account ID. Required in Equinix Fabric as authorization key."
}

variable "alicloud_access_key" {
  type        = string
  description = "This is the Alicloud access key. It must be provided, but it can also be sourced from the ALICLOUD_ACCESS_KEY environment variable."
  default     = ""
}

variable "alicloud_secret_key" {
  type        = string
  description = "This is the Alicloud secret key. It must be provided, but it can also be sourced from the ALICLOUD_SECRET_KEY environment variable."
  default     = ""
}

variable "alicloud_express_connect_bgp_customer_peer_ip" {
  type        = string
  description = "The BGP IPv4 address (in CIDR notation) for the router on the Equinix end of the BGP session."
  default     = "10.0.0.17/30"
}

variable "alicloud_express_connect_bgp_cloud_peer_ip" {
  type        = string
  description = "The BGP IPv4 address for Alibabas's end of the BGP session."
  default     = "10.0.0.18"
}

variable "alicloud_express_connect_bgp_customer_asn" {
  type        = number
  description = <<EOF
  The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration on the Equinix end
  of the BGP session.
  EOF
  default     = 65000
}

variable "alicloud_express_connect_bgp_auth_key" {
  type        = string
  description = "The key for BGP MD5 authentication. Only applicable if your system requires MD5 authentication."
  default     = ""
}


variable "alicloud_configure_bgp" {
  type        = bool
  description = <<EOF
  Creation and management of an Alibaba BGP group and a BGP peer. 
  See the [configure bgp](https://www.alibabacloud.com/help/en/express-connect/latest/configure-bgp) guide for more details.
  EOF
  default     = true
}
