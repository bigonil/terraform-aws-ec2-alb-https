variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "cert_arn" {
  type = string
}

variable "ec2_id" {
  type = string
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}