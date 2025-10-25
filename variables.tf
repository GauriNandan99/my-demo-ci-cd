variable "region" {
  type        = string
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
    enable_dns_hostnames = true
    tags = {
      Name = "my-vpc"
    }
  }
}


variable "public_subnets_config" {
  type = list(object({
    cidr_block = string
    az         = string
    tags       = map(string)
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
    cidr_block = string
    az         = string
    tags       = map(string)
  }))
  description = "private subnets configuration"
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

variable "security_group" {
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
  default = {
    name        = "demo-nop-sg"
    description = "security group"
    inbound_rules = [{
      port        = "5000"
      protocol    = "tcp"
      source      = "0.0.0.0/0"
      description = "open tcp port"
      },
      {
        port        = "22"
        protocol    = "tcp"
        source      = "0.0.0.0/0"
        description = "open ssh port"
    }]
  }
}

variable "db_security_group" {
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
  default = {
    name        = "demo-nop-db"
    description = "db security group"
    inbound_rules = [{
      port        = "3306"
      protocol    = "tcp"
      source      = "10.100.0.0/16"
      description = "open tcp port"
    }]
  }

}

variable "lb_security_group" {
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
  default = {
    name        = "demo-nop-lb"
    description = "LB security group"
    inbound_rules = [{
      port        = "80"
      protocol    = "tcp"
      source      = "0.0.0.0/0"
      description = "open tcp port"
    }]
  }

}


variable "info_ami" {
  description = "AMI information"
  type = object({
    id       = string
    username = string
  })
  default = {
    id = ""
    username = "ubuntu"
  }
}

#launch template config
variable "lbasg_template_details" {
  type = object({
    name                        = string
    instance_type               = string
    key_name                    = string
    #script_path                 = string
    security_group_ids          = list(string)
    associate_public_ip_address = bool
  })
  default = {
    name                        = "demo-nop"
    instance_type               = "t2.micro"
    key_name                    = "my_idrsa"
    #script_path                 = "installdemo.sh"
    security_group_ids          = []
    associate_public_ip_address = true
  }

}

#scaling size or limits
variable "lbasg_scaling_details" {
  type = object({
    min_size   = number
    max_size   = number
    subnet_ids = list(string)
  })
  default = {
    min_size   = 1
    max_size   = 2
    subnet_ids = []
  }

}

#lb configuration
variable "lb_details" {
  type = object({
    type               = string
    internal           = bool
    security_group_ids = list(string)
    subnet_ids         = list(string)
    vpc_id             = string
    application_port   = number
    port               = number

  })
  default = {
    type               = "application"
    internal           = false
    security_group_ids = []
    subnet_ids         = []
    vpc_id             = ""
    application_port   = 5000
    port               = 80
  }

}