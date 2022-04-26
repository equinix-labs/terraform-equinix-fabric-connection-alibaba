# CMD tool to manage Alibaba Cloud Virtual border routers

Implementation of `ModifyVirtualBorderRouterAttribute` API required to confirm connections but not yet available in alibaba cloud terraform provider.

Please, check this issue for more details: https://github.com/aliyun/terraform-provider-alicloud/issues/4732

## Using the tool

To confirm the creation of the VBR:

`alibaba-manage-vbr confirm-creation --access-key=<accessKey> --secret-key=<accessSecret> -region=eu-central-1 --vbr-id=vbr-1234678 --cloud-ip=10.0.0.1 --customer-ip=10.0.0.2 --subnet-mask=255.255.255.252`
