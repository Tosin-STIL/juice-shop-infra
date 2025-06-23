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

module "codebuild_build" {
  source              = "../../modules/codebuild"
  project             = "juice-shop"
  build_name          = "build"
  description         = "Builds Docker image and pushes to ECR"
  codebuild_role_arn  = module.iam.codebuild_role_arn
  source_repo         = "https://github.com/YOUR_ORG/juice-shop-app.git"
  buildspec_path      = "buildspec.yml"
  environment         = "prod"
  privileged_mode     = true
  environment_variables = {
    ECR_REPO = "590183956481.dkr.ecr.eu-west-1.amazonaws.com/juice-shop-app"
  }
}
