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
  container_definitions = "${path.module}/definitions/juice-shop-container.json"
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
    ECR_REPO = module.ecr.repository_url
  }
}

data "aws_ssm_parameter" "github_token" {
  name            = "/sovtech/GITHUB_DEPLOY_TOKEN"
  with_decryption = true
}

data "aws_ssm_parameter" "snyk_token" {
  name           = "/sovtech/SNYK_TOKEN"
  with_decryption = true
}

data "aws_ssm_parameter" "sonar_token" {
  name           = "/sovtech/SONARQUBE_TOKEN"
  with_decryption = true
}


module "codebuild_security_scan" {
  source              = "../../modules/codebuild"
  project             = "juice-shop"
  build_name          = "security-scan"
  description         = "Runs SAST, SCA, and IaC scans"
  codebuild_role_arn  = module.iam.codebuild_role_arn
  source_repo         = "https://github.com/YOUR_ORG/juice-shop-app.git"
  buildspec_path      = "buildspec-security.yml"
  environment         = "prod"
  privileged_mode     = false
  environment_variables = {
    SNYK_TOKEN        = data.aws_ssm_parameter.snyk_token.value
    SONARQUBE_TOKEN   = data.aws_ssm_parameter.sonar_token.value
  }
}

module "codepipeline" {
  source                     = "../../modules/codepipeline"
  project                    = "juice-shop"
  environment                = "prod"
  pipeline_role_arn          = module.iam.codepipeline_role_arn
  artifact_bucket            = module.storage.artifact_bucket_name
  github_owner               = "Tosin-STIL"
  github_repo                = "juice-shop-app"
  github_branch              = "main"
  codestar_connection_arn    = "arn:aws:codeconnections:eu-west-1:590183956481:connection/8266d7de-ec49-4c52-a029-15ab5e920ca1"
  build_project_name         = module.codebuild_build.project_name
  security_scan_project_name = module.codebuild_security_scan.project_name
}


module "iam" {
  source  = "../../modules/iam"
  project = "juice-shop"
}

module "storage" {
  source      = "../../modules/storage"
  project     = "juice-shop"
  environment = "prod"
}

module "security" {
  source  = "../../modules/security"
  project = "juice-shop"
  vpc_id  = module.vpc.vpc_id
}

module "ecr" {
  source      = "../../modules/ecr"
  project     = "juice-shop"
  environment = "prod"
  repo_name   = "juice-shop-app"
}

module "ecs_sonarqube" {
  source                = "../../modules/ecs"
  project               = "juice-shop"
  service_name          = "sonarqube"
  task_family           = "sonarqube-task"
  container_name        = "sonarqube"
  container_port        = 9000
  cpu                   = "1024"
  memory                = "2048"
  desired_count         = 1
  execution_role_arn    = module.iam.execution_role_arn
  task_role_arn         = module.iam.task_role_arn
  subnet_ids            = module.vpc.public_subnet_ids
  security_group_ids    = [module.security.ecs_sg_id]
  target_group_arn      = module.alb.sonarqube_tg_arn
  container_definitions = "${path.module}/definitions/sonarqube-container.json"
}

data "aws_codestarconnections_connection" "github" {
  name = "juice-shop-github-connection"
}
