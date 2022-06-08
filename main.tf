module "website" {
  source          = "./s3_website"
  domain_name     = var.domain_name
  tags_validation = var.tag_departamento
}