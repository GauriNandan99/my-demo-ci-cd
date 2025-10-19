#vpc with subnets

module "vpc" {
  source         = "git::https://github.com/GauriNandan99/my-devops-project.git//modules/vpc"
  vpc_info       = var.vpc_info
  public_subnets = var.public_subnets_config

  private_subnets = var.private_subnets_config
}

module "sg" {
  source         = "git::https://github.com/GauriNandan99/my-devops-project.git//modules/sg"
    vpc_id = module.vpc.id
        security_group_info = var.security_group
    
}

# db security group to open 5000 port 
module "dbsg" {
    source = "git::https://github.com/GauriNandan99/my-devops-project.git//modules/sg"
    vpc_id = module.vpc.id
    security_group_info = var.db_security_group
}

module "lbsg" {
    source = "git::https://github.com/GauriNandan99/my-devops-project.git//modules/sg"
    vpc_id = module.vpc.id
    security_group_info = var.lb_security_group
}