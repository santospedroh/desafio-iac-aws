terraform {
  backend "s3" {
    bucket = "terraform-tfstate-pedro"
    key    = "desafio-03/terraform.tfstate"
    region = "us-east-1"
  }
}
