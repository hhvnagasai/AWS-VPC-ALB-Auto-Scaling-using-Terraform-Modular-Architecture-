# 1. module vpc

module "vpc" {
  source     = "./modules/vpc"
  cidr_block = "10.0.0.0/16"
}

# 2. module public subnet

module "public_subnet" {
  source = "./modules/public_subnet"

  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
}
module "public_subnet_2" {
  source = "./modules/public_subnet"

  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "ap-south-1b"
}

# 3. module private subnet

module "private_subnet" {
  source = "./modules/private_subnet"

  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
}

# 4. module internet gateway

module "igw" {
  source = "./modules/internet_gateway"

  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  public_subnet_id = module.public_subnet.public_subnet_id
}

# 5 . module public-rt

module "public_route_table" {
  source = "./modules/public_route_table"

  vpc_id           = module.vpc.vpc_id
  igw_id           = module.igw.igw_id
  public_subnet_id = module.public_subnet.public_subnet_id
}

# 6. private_route_table

module "private_route_table" {
  source = "./modules/private_route_table"

  vpc_id            = module.vpc.vpc_id
  private_subnet_id = module.private_subnet.private_subnet_id
  nat_gateway_id    = module.nat_gateway.nat_gateway_id
}

# 7. security group

module "alb_sg" {
  source = "./modules/alb_sg"

  vpc_id = module.vpc.vpc_id
}
module "ec2_sg" {
  source = "./modules/ec2_sg"

  vpc_id    = module.vpc.vpc_id
  alb_sg_id = module.alb_sg.alb_sg_id
}

# 8.  ec2-instance

module "ec2_instance" {
  source = "./modules/ec2_instance"

  ami_id            = "ami-0e12ffc2dd465f6e4"   # Replace with real AMI
  instance_type     = "t3.micro"
  subnet_id         = module.private_subnet.private_subnet_id
  security_group_id = module.ec2_sg.ec2_sg_id
}

# 9 ami

module "ami" {
  source = "./modules/ami"

  instance_id = module.ec2_instance.instance_id
}

# 10. launch_template

module "launch_template" {
  source = "./modules/launch_template"

  ami_id            = module.ami.ami_id
  instance_type     = "t3.micro"
  security_group_id = module.ec2_sg.ec2_sg_id
}

# 11 target-group

module "target_group" {
  source = "./modules/target_group"

  vpc_id  = module.vpc.vpc_id
  port    = 80
  protocol = "HTTP"
}

# 12. alb
module "alb" {
  source = "./modules/alb"

  subnet_ids        = [module.public_subnet.public_subnet_id, module.public_subnet_2.public_subnet_id]  
  security_group_id = module.alb_sg.alb_sg_id
  target_group_arn  = module.target_group.target_group_arn
}

# 13 . autoscaling
locals {
  scaling = var.stress_mode ? var.stress_scaling : var.normal_scaling
}

module "autoscaling" {
  source = "./modules/autoscaling"

  launch_template_id = module.launch_template.launch_template_id
  subnet_ids         = [module.private_subnet.private_subnet_id]
  target_group_arn   = module.target_group.target_group_arn

  desired_capacity = local.scaling.desired
  min_size         = local.scaling.min
  max_size         = local.scaling.max
}
