terraform {
  backend "s3" {
    bucket = "avascoperta-devops-kubernetes"
    region = "eu-west-1"
    key = "terraform"
  }

  required_version = "> 0.11.7"
}

variable aws_region {
    default = "eu-west-1"
}

provider "aws" {
    region = "${var.aws_region}"
}
