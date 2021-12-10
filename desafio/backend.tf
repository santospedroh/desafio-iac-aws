terraform {
  backend "s3" {
    bucket = "terraform-tfstate-pedro"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}