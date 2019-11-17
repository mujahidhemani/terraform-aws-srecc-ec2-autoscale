# SRE Code Challenge - Terraform Autoscaling Module for outyet

This Terraform module creates an autoscaling group for the outyet app. It creates the autoscaling group, along with the launch config, and security groups to manage the network access to the autoscaling EC2 instances.

NOTE:
- The AMI ID specified in the launch configuration is hardcoded, this AMI is built by Packer and is publicly available
- Updating the launch config will create a new autoscaling group. The new autoscaling group is created alongside the old one, the old one will terminate once the new autoscaling group is launched and healthy
- The min, max and desired sizes are hardcoded, the module assumes that the minimum and desired sizes are 3 instances; if used with the `mujahidhemani/srecc-vpc/aws` module, that will place one EC2 autoscaling instance per availability zone
- The EC2 autoscaling instances are launched in backend (private) subnets, they can reach HTTP/HTTPS ports on the internet. They can only be accessed by HTTP on port 8080 by instances or load balancers in the same security group

## Usage
```hcl
module "srecc-ec2-backend" {
  source           = "mujahidhemani/srecc-ec2-autoscale/aws"
  version          = "1.2.0"
  vpc_id           = "${module.srecc-vpc.vpc_id}"
  subnet_ids       = "${module.srecc-vpc.backend_subnet_ids}"
  target_group_arn = "${module.srecc-frontend.target_group_arn}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| subnet\_ids | A list of subnet IDs to launch the EC2 instances in | list(string) | n/a | yes |
| target\_group\_arn | The ARN of an AWS load balancer target group to associate the autoscaling group with | string | n/a | yes |
| vpc\_id | The VPC ID to associate the EC2 autoscaling group with | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| autoscaling\_group\_name | The Terraform generated name of the outyet autoscaling group |
| backend\_sg\_id | The security group ID of the outyet security group created by this module |

