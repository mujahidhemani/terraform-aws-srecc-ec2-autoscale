variable "vpc_id" {
  description = "The VPC ID to associate the EC2 autoscaling group with"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to launch the EC2 instances in"
}

variable "target_group_arn" {
  description = "The ARN of an AWS load balancer target group to associate the autoscaling group with"
}
