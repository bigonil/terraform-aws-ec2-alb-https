# Root main.tf (orchestrator)
terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "LB-GlobexInfraOps"
    workspaces {
      name    = "terraform-aws-ec2-alb-https"
      project = "learn_terraform_tutorials"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Cerca certificato SSL già importato in ACM
data "aws_acm_certificate" "imported" {
  domain      = "www.lb-aws-labs.link"
  statuses    = ["ISSUED"]
  most_recent = true
}

module "alb" {
  source     = "./modules/aws_alb"
  subnet_ids = var.subnet_ids
  vpc_id     = var.vpc_id
  alb_sg_id  = aws_security_group.alb_sg.id
  cert_arn   = data.aws_acm_certificate.imported.arn
  ec2_id     = aws_instance.web.id
}

resource "aws_key_pair" "default" {
  key_name   = "ec2-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = "t3.micro"
  key_name                    = aws_key_pair.default.key_name
  subnet_id                   = var.subnet_ids[0]
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  user_data                   = file("user_data.sh")

  tags = {
    Name = "WebServer"
  }
}

resource "aws_route53_record" "alb_dns" {
  name    = "www.lb-aws-labs.link"
  type    = "A"
  zone_id = var.zone_id

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}
