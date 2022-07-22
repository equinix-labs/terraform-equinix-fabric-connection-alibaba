variable "equinix_provider_client_id" {
  type        = string
  description = <<EOF
  API Consumer Key available under 'My Apps' in developer portal. This argument can also be specified with the
  EQUINIX_API_CLIENTID shell environment variable.
  EOF
  default     = null
}

variable "equinix_provider_client_secret" {
  type        = string
  description = <<EOF
  API Consumer secret available under 'My Apps' in developer portal. This argument can also be specified with the
  EQUINIX_API_CLIENTSECRET shell environment variable.
  EOF
  default     = null
}

variable "device_id" {
  type = string
  description = <<EOF
  (Required) The ID of the (Network Edge virtual device](https://github.com/equinix/terraform-provider-equinix/tree/master/examples/edge-networking)
  from which the connection would originate.
  EOF
}

variable "alicloud_account_id" {
  type = string
  description = <<EOF
  (Required) Your
  [Alibaba account ID](https://www.alibabacloud.com/help/en/marketplace/latest/how-do-i-get-my-account-id-for-third-party-support)."
  EOF
}
