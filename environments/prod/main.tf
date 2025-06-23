module "vpc" {
  source              = "../../modules/vpc"
  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  project             = "juice-shop"
}

module "ecs_juice_shop" {
  source                = "../../modules/ecs"
  project               = "juice-shop"
  service_name          = "app"
  task_family           = "juice-shop-task"
  container_name        = "juice-shop"
  container_port        = 3000
  cpu                   = "512"
  memory                = "1024"
  desired_count         = 1
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_ids    = [module.security.ecs_sg_id]
  target_group_arn      = module.alb.juice_shop_tg_arn
  container_definitions = file("${path.module}/definitions/juice-shop-container.json")
}

module "alb" {
  source            = "../../modules/alb"
  project           = "juice-shop"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_id = module.security.alb_sg_id
}
