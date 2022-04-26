variable "port_name" {
  type        = string
  description = <<EOF
  Name of the [Equinix Fabric port](https://docs.equinix.com/en-us/Content/Interconnection/Fabric/ports/Fabric-port-details.htm)
  from which the connection would originate.
  EOF
}

variable "alicloud_account_id" {
  type = string
  description = "Your [Alibaba account ID](https://www.alibabacloud.com/help/en/marketplace/latest/how-do-i-get-my-account-id-for-third-party-support)."
}
