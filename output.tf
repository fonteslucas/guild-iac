output "arn" {
  value = module.S3.arn_teste
}

output "arn_role" {
  value = module.IAM.role-id
}