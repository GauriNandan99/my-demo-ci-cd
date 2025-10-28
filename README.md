[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Infrastructure-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![Packer](https://img.shields.io/badge/Packer-Pre--Baked%20AMI-02A8EF?logo=packer)](https://www.packer.io/)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)


This repository demonstrates how to use Terraform modules — where you simply pass input values to the modules that create AWS resources.
It includes examples of N‑tier application creation using modules and CI/CD pipeline implementation.

## stage 1
# N-Tier Application Infrastructure - AWS Terraform


The setup is designed for stateless and microservice-based applications, ensuring high availability, consistency, and zero manual configuration drift.
A scalable, modular N-tier application infrastructure on AWS using Terraform with Auto Scaling capabilities powered by pre-baked AMIs.

---

## Overview
This project demonstrates a fully automated, immutable infrastructure deployment pipeline using Azure DevOps, Terraform, and Packer.
It implements a production-grade N-tier application architecture on AWS using Infrastructure as Code (IaC) principles. The infrastructure is designed to be highly available, scalable, and cost-effective across multiple environments.

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


## Stage-2  Infrastructure Automation with CI/CD Pipeline

## Pipeline Architecture

### Repository Structure

```
infrastructre-creation-repo/
├── src/                         # Application source code
│ └── code/                      
├── deployment/                  # Deployment configurations
│ ├── packer/                    # Packer templates and scripts
│ │ ├── installnopscript.sh      
│ │ ├── nop.pkr.hcl              
│ │ ├── nopCommerce.service 
│ │ └── nopCommerce.zip 
│ └── terraform/                  # tf files
│ ├── main.tf
│ ├── variables.tf
│ ├── outputs.tf
│ └── providers.tf
└── azure-pipelines.yml           # Pipeline definition
```
### Pipeline Stages

1. **Build Stage**: Compiles source code and creates deployment artifacts
2. **Packer AMI Stage**: Generates pre-configured Amazon Machine Image with application code and dependencies
3. **Terraform Stage**: Provisions/updates infrastructure using the new AMI

## Key Benefits & Technical Approach

###  Immutable Infrastructure Pattern

- **Each code change triggers complete AMI rebuild** with updated application
- **Eliminates runtime dependency installation** during instance launch and ASG
- **Ensures consistent, versioned infrastructure** across all environments
- **suitable for**: Stateless applications, microservices, and web applications


## High Availability & Scalability Features

### Multi-AZ Deployment

```hcl
# Auto Scaling Group across multiple Availability Zones
resource "aws_autoscaling_group" "app" {
  vpc_zone_identifier = [
    "subnet-ap-south-1a",
    "subnet-ap-south-1b", 
    "subnet-ap-south-1c"
  ]
  min_size            = 2
  max_size            = 6
  desired_capacity    = 3
  
  health_check_type         = "ELB"
  health_check_grace_period = 300
  
  tags = [
    {
      key                 = "Name"
      value               = "app-server"
      propagate_at_launch = true
    }
  ]
}
```

### Zero-Downtime Deployments with Instance Refresh

```hcl
instance_refresh {
  strategy = "Rolling"
  preferences {
    min_healthy_percentage = 66    # Maintains service availability
    instance_warmup        = 30    # Health check grace period
  }
}
```
**How it works:**
- Instance Refresh automatically replaces old instances with new ones in a rolling fashion
- Maintains desired capacity throughout the process
- Ensures minimum 66% of instances remain healthy during update
- New instances launch with updated AMI containing latest application code

**Benefits:**
-  Zero downtime during deployments
-  Automatic rollback on health check failures
-  Gradual rollout reduces risk
-  Application always available to users

---

## Environment Management Recommended

### Terraform Workspaces for Environment Isolation

```bash
# Pipeline commands for environment separation
terraform workspace select dev
terraform workspace new staging
terraform workspace select prod
```


**Benefits:**
- Isolated state for each environment
- Prevents accidental changes to production
- Easy environment switching
- Parallel deployments possible

---

## Self-Hosted Azure DevOps Agent

 **EC2 Instance with necessary tooling pre-installed:**

- **.NET ** (for nopCommerce build)
- **Terraform** (infrastructure provisioning)
- **Packer** (AMI creation)
- **AWS CLI** (cloud operations)

You can implement branching strategies in this Azure DevOps CI/CD pipeline to manage deployments effectively — for example, using feature, develop, staging, and main (production) branches. Configure production deployments to require manual approval from the production deployment team for added control.

When any code change or update is made, the pipeline will automatically trigger: the code is built, a new AMI with the updated code is generated, and Terraform applies it to the infrastructure. This approach eliminates the need to reinstall code and dependencies each time new instances are launched by the Auto Scaling Group.


## License

This project is licensed under the [Apache License 2.0](LICENSE).
