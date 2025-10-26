[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Infrastructure-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![Packer](https://img.shields.io/badge/Packer-Pre--Baked%20AMI-02A8EF?logo=packer)](https://www.packer.io/)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)


This repository demonstrates how to use Terraform modules — where you simply pass input values to the modules that create AWS resources.
It includes examples of N‑tier application creation using modules and CI/CD pipeline implementation.

## stage 1
# N-Tier Application Infrastructure - AWS Terraform



A scalable, modular N-tier application infrastructure on AWS using Terraform with Auto Scaling capabilities powered by pre-baked AMIs.

---

## Overview

This project implements a production-grade N-tier application architecture on AWS using Infrastructure as Code (IaC) principles. The infrastructure is designed to be highly available, scalable, and cost-effective across multiple environments.

### Key Features

-  **Modular Architecture** - Reusable Terraform modules from remote Git repository
-  **Multi-AZ Deployment** - High availability across availability zones
-  **Auto Scaling** - Automatic horizontal scaling based on demand
-  **Load Balancing** - Application Load Balancer with target groups
-  **Pre-Baked AMIs** - Using Packer for rapid instance deployment
-  **Network Isolation** - Public and private subnets with proper security
-  **Security Groups** - Layered security for ALB, application, and database tiers
-  **Remote State** - S3 backend with state locking
-  **Variable-Driven** - Fully configurable through `terraform.tfvars`

---

## Repository Structure

```
.
├── main.tf                    # Root module 
├── providers.tf               # AWS provider + S3 backend configuration
├── variables.tf               # Input variable definitions
├── terraform.tfvars           # you can add Variable values (environment-specific)
├── outputs.tf                 # Output definitions
└── README.md                  # This file
```

### Remote Modules Used

All modules are sourced from my repo: `https://github.com/GauriNandan99/my-devops-project.git`

- **VPC Module** (`modules/vpc`) - VPC, Subnets, Route Tables, Internet Gateway
- **Security Group Module** (`modules/sg`) - Security groups for different tiers
- **Auto Scaling Module** (`modules/asg`) - Launch Template, ASG, ALB, Target Groups

---

## Components Overview

### 1. VPC Module
Creates the network foundation:
- VPC with custom CIDR block
- Public subnets (for ALB)
- Private subnets (for application instances)
- Internet Gateway
- Route tables and associations

### 2. Security Groups
Three security group modules for different layers:
- **ALB Security Group** (`lbsg`) - Allows HTTP/HTTPS traffic from internet
- **Application Security Group** (`sg`) - Allows traffic only from ALB
- **Database Security Group** (`dbsg`) - Opens port 5000 for database connections

### 3. Load Balancer + Auto Scaling
Combined module (`lbasg`) that creates:
- **Launch Template** - Uses pre-baked AMI from Packer
- **Auto Scaling Group** - Manages EC2 instance lifecycle
- **Application Load Balancer** - Distributes traffic across instances
- **Target Group** - Routes traffic to healthy instances
- **Scaling Policies** - Auto scales based on metrics

---

## Why Pre-Baked AMIs with Packer?

### The Question
*"Why use pre-baked AMIs when I could just use EC2 user data to install the application?"*

### The Answer

#### 1. **Faster Auto Scaling**
When the Auto Scaling Group needs to launch new instances during traffic spikes:

**User Data Approach:**
```
Launch Instance → Run User Data Script → Install Dependencies 
→ Download Application → Configure → Start Service
 Time: 5-10 minutes
```

**Pre-Baked AMI Approach:**
```
Launch Instance → Application Already Installed → Start Service
 Time: 1-2 minutes
```

**Impact:** In production, every second matters during traffic spikes. Faster instance launch means better response to demand.

#### 2. **Reliability & Consistency**
**User Data Risks:**
- Package repositories might be unavailable
- Network failures during downloads
- Version inconsistencies across instances
- Failed installations create unhealthy instances

**Pre-Baked AMI Benefits:**
- Application tested before AMI creation
- Identical configuration on every instance
- No external dependencies during launch
- Predictable and stable deployments

#### 3. **Security**
**User Data:**
```bash
#!/bin/bash
curl https://example.com/app.tar.gz -o app.tar.gz  # External dependency
apt-get install package  # Version might change
```

**Pre-Baked AMI:**
- AMI scanned for vulnerabilities before use
- No external downloads during instance launch
- Immutable infrastructure pattern
- Controlled and audited build process

#### 4. **Reduced Boot Time**
- No compilation or installation during instance startup
- Application service starts immediately
- Faster time-to-serve traffic
- Better auto-scaling responsiveness

#### 5. **Cost Optimization**
- Instances become healthy faster
- Less wasted compute time during installation
- More efficient use of auto-scaling
- Lower overall operational costs

### When to Use User Data vs Pre-Baked AMI

**Use User Data when:**
- Development/testing environments
- Infrequent deployments
- Simple, quick installations
- Instance-specific configurations

**Use Pre-Baked AMI when:**
- Production environments  (This project)
- Auto-scaling required 
- Fast launch time critical 
- Consistency is paramount 
- Security is a concern 

---

## Pre Baked AMI in this project
- Install Packer [Download here](https://www.packer.io/downloads)
- Download nopCommerce  [Get it from the official site](https://www.nopcommerce.com/en/download-nopcommerce)
- Install nopCommerce Follow the [Linux installation guide](https://docs.nopcommerce.com/en/installation-and-upgrading/installing-nopcommerce/installing-on-linux.html#get-nopcommerce) 
- The Packer template (.pkr.hcl) and required installation script can be found in the nop-commerce/ folder.




---

## Prerequisites

### Required Software
- **Terraform** >= 6.5.0 - [Install](https://www.terraform.io/downloads)
- **AWS CLI** >= 2.0 - [Install](https://aws.amazon.com/cli/)
- **Packer** >= 1.9.0 - [Install](https://www.packer.io/downloads) (for building AMIs)
- **Git** - For cloning repository


**Note** - This demo project does not include a database module. You can create a reusable module in a similar way to the other modules in this project, or you can directly use the RDS community module from [terraform-aws-modules/rds/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds/aws/latest).
You can also add additional modules as per your requirements.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
