terraform {
  backend "s3" {
    bucket  = "larave-fargate-test-tfstate"
    key     = "example/prod/cicd/app_foobar_v1.0.0.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}