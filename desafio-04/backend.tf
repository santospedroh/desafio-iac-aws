terraform {
  backend "s3" {
    bucket = "terraform-tfstate-pedro"
    key    = "desafio-04/terraform.tfstate"
    region = "us-east-1"
  }
}
