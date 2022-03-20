# 自分のAWSアカウントIDを参照
data "aws_caller_identity" "self" {}

data "aws_region" "current" {}

# tfstate内のoutputを参照
data "terraform_remote_state" "network_main" {
  backend = "s3"

  config = {
    bucket  = "larave-fargate-test-tfstate"
    key     = "${local.system_name}/${local.env_name}/network/main_v1.0.0.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}

data "terraform_remote_state" "routing_app_link" {
  backend = "s3"

  config = {
    bucket  = "larave-fargate-test-tfstate"
    key     = "${local.system_name}/${local.env_name}/routing/app_link_v1.0.0.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}
