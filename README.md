# Terraform EC2 + ALB + HTTPS Deployment

🚀 Deploy a secure EC2 web server behind an HTTPS-enabled Application Load Balancer using Terraform. Includes automatic ACM certificate provisioning, Route53 DNS validation, and modular Terraform structure.

This repository provides a complete Terraform setup to deploy a secure web server behind an **Application Load Balancer (ALB)** with **HTTPS** enabled via **AWS ACM (Amazon Certificate Manager)**. The domain used in this setup is `lb-aws-labs.link`.

---

## 📦 Features

- 🚀 Deploys an EC2 instance with Apache or NGINX using `user_data`
- 🛡️ Configures Security Groups for HTTP/HTTPS
- 🌐 Creates a public Application Load Balancer
- 🔐 Issues and validates an SSL certificate via ACM (DNS-based using Route53)
- ♻️ Modular structure (reusable `alb/` and `acm/` modules)
- 📎 Redirects HTTP → HTTPS traffic automatically

---

## 📁 Project Structure

terraform-aws-ec2-alb-https/ ├── main.tf ├── variables.tf ├── output.tf ├── terraform.tfvars ├── user_data.sh ├── modules/ │ ├── alb/ │ └── acm/ └── README.md


---

## ☁️ Cloud Integration

Per abilitare l'integrazione cloud, aggiungi il seguente blocco di configurazione a uno qualsiasi dei tuoi file `.tf` nella directory dove esegui Terraform:

````hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

