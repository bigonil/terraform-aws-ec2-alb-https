variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "zone_id" {
  type = string
}

variable "public_key_path" {
  description = "Percorso assoluto del file della chiave pubblica SSH"
  type        = string
}