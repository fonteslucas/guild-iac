module "s3-object" {
    source = "./s3-object"
}

output "s3-object" {
    value = module.s3-object.website_endpoint
}