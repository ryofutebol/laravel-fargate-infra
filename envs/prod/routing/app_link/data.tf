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

data "terraform_remote_state" "log_alb" {
  backend = "s3"

  config = {
    bucket  = "larave-fargate-test-tfstate"
    key     = "${local.system_name}/${local.env_name}/log/alb_v1.0.0.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}
