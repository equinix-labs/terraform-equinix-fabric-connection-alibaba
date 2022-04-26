package main

import (
	"github.com/aliyun/alibaba-cloud-sdk-go/services/ecs"
	"fmt"
)


func ModifyVirtualBorderRouterAttribute(client ecs.Client, vbrId, localGatewayIp, peerGatewayIp, peeringSubnetMask string) (*ecs.ModifyVirtualBorderRouterAttributeResponse, error){
	request := ecs.CreateModifyVirtualBorderRouterAttributeRequest()
	request.Scheme = "https"

	request.VbrId = vbrId
	request.LocalGatewayIp = localGatewayIp
	request.PeerGatewayIp = peerGatewayIp
	request.PeeringSubnetMask = peeringSubnetMask

	response, err := client.ModifyVirtualBorderRouterAttribute(request)
	if err != nil {
		return nil, fmt.Errorf("ModifyVirtualBorderRouterAttribute request: %+v\n - error: %w", request, err)
	}
	return response, nil
}

func DescribeVirtualBorderRouter(client ecs.Client, vbrId string) (*ecs.VirtualBorderRouterType, error) {
	request := ecs.CreateDescribeVirtualBorderRoutersRequest()
	request.Scheme = "https"

	filterValues := []string{vbrId}
	request.Filter = &[]ecs.DescribeVirtualBorderRoutersFilter{
		{
		  Key: "VbrId",
		  Value: &filterValues,
		},
	}
	
	response, err := client.DescribeVirtualBorderRouters(request)
	if err != nil {
		return nil, fmt.Errorf("DescribeVirtualBorderRouter request: %+v\n - error: %w", request, err)
	}
	return &response.VirtualBorderRouterSet.VirtualBorderRouterType[0], nil
}
