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

variable "alicloud_account_id" {
  type = string
  description = <<EOF
  (Required) Your
  [Alibaba account ID](https://www.alibabacloud.com/help/en/marketplace/latest/how-do-i-get-my-account-id-for-third-party-support)."
  EOF
}

variable "metal_project_id" {
  type        = string
  description = "(Required) ID of the project where the connection is scoped to, used to look up the project."
}

variable "fabric_notification_users" {
  type        = list(string)
  description = "A list of email addresses used for sending connection update notifications."
  default = ["example@equinix.com"]
}

variable "fabric_destination_metro_code" {
  type        = string
  description = "Destination Metro code where the connection will be created."
  default     = "SV"
}

variable "fabric_speed" {
  type        = number
  description = <<EOF
  Speed/Bandwidth in Mbps to be allocated to the connection. If unspecified, it will be used the minimum
  bandwidth available for the `Equinix Metal` service profile. Valid values are
  (50, 100, 200, 500, 1000, 2000, 5000, 10000).
  EOF
  default     = 50
}

variable alicloud_region {
  type        = string
  description = <<EOF
  The name of the region to select, e.g. eu-central-1. 'alicloud_region' and 'fabric_destination_metro_code' must
  correspond to same location. Check [Available regions](https://www.alibabacloud.com/global-locations).
  EOF
  default = "us-west-1" // Silicon Valley (SV)
}