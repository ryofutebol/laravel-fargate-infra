terraform {
  backend "s3" {
    bucket  = "larave-fargate-test-tfstate"
    key     = "example/prod/app/foobar_v1.0.2.tfstate"
    region  = "ap-northeast-1"
    profile = "terraform"
  }
}