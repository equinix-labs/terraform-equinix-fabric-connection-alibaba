variable "device_id" {
  type = string
  description = <<EOF
  The ID of the (Network Edge virtual device](https://github.com/equinix/terraform-provider-equinix/tree/master/examples/edge-networking)
  from which the connection would originate.
  EOF
}

variable "alicloud_account_id" {
  type = string
  description = "Your [Alibaba account ID](https://www.alibabacloud.com/help/en/marketplace/latest/how-do-i-get-my-account-id-for-third-party-support)."
}
