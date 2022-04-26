output "fabric_connection_uuid" {
  description = "Unique identifier of the connection."
  value       = module.equinix-fabric-connection.primary_connection.uuid
}

output "fabric_connection_name" {
  description = "Name of the connection."
  value       = module.equinix-fabric-connection.primary_connection.name
}

output "fabric_connection_status" {
  description = "Connection provisioning status."
  value       = module.equinix-fabric-connection.primary_connection.status
}

output "fabric_connection_provider_status" {
  description = "Connection provisioning provider status."
  value       = module.equinix-fabric-connection.primary_connection.provider_status
}

output "fabric_connection_speed" {
  description = "Connection speed."
  value       = module.equinix-fabric-connection.primary_connection.speed
}

output "fabric_connection_speed_unit" {
  description = "Connection speed unit."
  value       = module.equinix-fabric-connection.primary_connection.speed_unit
}

output "fabric_connection_seller_metro" {
  description = "Connection seller metro code."
  value       = module.equinix-fabric-connection.primary_connection.seller_metro_code
}

output "fabric_connection_seller_region" {
  description = "Connection seller region."
  value       = module.equinix-fabric-connection.primary_connection.seller_region
}

output "network_edge_bgp_state" {
  description = "Network Edge device BGP peer state."
  value       = try(equinix_network_bgp.this[0].state, null)
}

output "network_edge_bgp_provisioning_status" {
  description = "Network Edge device BGP peering configuration provisioning status."
  value       = try(equinix_network_bgp.this[0].provisioning_status, null)
}

output "alicloud_virtual_border_router_id" {
  depends_on = [
    data.alicloud_express_connect_virtual_border_routers.this
  ]
  description = "Alibaba VBR ID."
  value       = local.vbr_id
}

output "alicloud_virtual_border_router_route_table_id" {
  depends_on = [
    data.alicloud_express_connect_virtual_border_routers.this
  ]
  description = "Alibaba VBR Route Table ID."
  value       = local.vbr_route_table_id
}

output "alicloud_vpc_bgp_group_id" {
  description = "Alibaba BGP Group ID. Returns null if `alicloud_configure_bgp` is false."
  value       = var.alicloud_configure_bgp ? alicloud_vpc_bgp_group.this[0].id : null
}

output "alicloud_vpc_bgp_group_cloud_asn" {
  description = "Alibaba BGP Group Cloud ASN. Returns null if `alicloud_configure_bgp` is false."
  value       = var.alicloud_configure_bgp ? alicloud_vpc_bgp_group.this[0].local_asn : null
}

output "alicloud_vpc_bgp_peer_id" {
  description = "Alibaba BGP Peer ID. Returns null if `alicloud_configure_bgp` is false."
  value       = var.alicloud_configure_bgp ? alicloud_vpc_bgp_peer.this[0].id : null
}