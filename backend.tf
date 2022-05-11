terraform {
  backend "s3" {
    key     = "guild/desafio-08.tfsate"
    bucket  = "backend-lfg"
    region  = "us-west-2"
    profile = "pocaccess"
  }
}