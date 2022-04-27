output "fabric_connection_id" {
  value = module.equinix-fabric-connection-alibaba.fabric_connection_uuid
}

output "fabric_connection_name" {
  value = module.equinix-fabric-connection-alibaba.fabric_connection_name
}

output "fabric_connection_status" {
  value = module.equinix-fabric-connection-alibaba.fabric_connection_status
}

output "network_edge_bgp_state" {
  description = "Network Edge device BGP peer state."
  value       = module.equinix-fabric-connection-alibaba.network_edge_bgp_state
}

output "network_edge_bgp_provisioning_status" {
  description = "Network Edge device BGP peering configuration provisioning status."
  value       = module.equinix-fabric-connection-alibaba.network_edge_bgp_provisioning_status
}

output "alicloud_virtual_border_router_id" {
  value = module.equinix-fabric-connection-alibaba.alicloud_virtual_border_router_id
}

output "alicloud_vpc_bgp_group_cloud_asn" {
  value = module.equinix-fabric-connection-alibaba.alicloud_vpc_bgp_group_cloud_asn
}
