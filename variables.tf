variable "region" {
  type        = strings
  description = "region"
  default     = "ap-south-1"
}

variable "vpc_info" {
  type = object({
    cidr_block           = string
    enable_dns_hostnames = bool
    tags                 = map(string)
  })
  description = "my vpc info"
  default = {
    cidr_block = "10.100.0.0/16"
    tags = {
      Name = "my-vpc"
    }
  }
}


variable "public_subnets_config" {
  type = list(object({
    cidr_block        = string
    az = string
    tags              = map(string)
  }))
  description = "public subnets configuration"
  default = [{
    cidr_block = "10.100.0.0/24"
    tags = {
      Name = "web1"
      Env  = "dev"
    }
    az = "ap-south-1a"
    }, {
    cidr_block = "10.100.1.0/24"
    tags = {
      Name = "web2"
      Env  = "dev"
    }
    az = "ap-south-1b"
  }]
}

variable "private_subnets_config" {
  type = list(object({
    cidr_block        = string
    az = string
    tags              = map(string)
  }))
  description = "public subnets configuration"
  default = [{
    cidr_block = "10.100.2.0/24"
    tags = {
      Name = "db1"
      Env  = "dev"
    }
    az = "ap-south-1a"
    }, {
    cidr_block = "10.100.3.0/24"
    tags = {
      Name = "db2"
      Env  = "dev"
    }
    az = "ap-south-1b"
  }]
}

variable "security_group_info" {
  type = object({
    name        = string
    description = string
    inbound_rules = list(object({
      protocol    = string
      port        = number
      source      = string
      description = string
    }))
  })
  default = [{
        name = "demo_nop"
        description = "security group"
        inbound_rules = [{
            port = "5000"
            protocol = "tcp"
            source = "0.0.0.0/0"
            description = "open tcp port"
        },
        {
            port = "22"
            protocol = "tcp"
            source = "0.0.0.0/0"
            description = "open ssh port"
        }]    
   }]
}