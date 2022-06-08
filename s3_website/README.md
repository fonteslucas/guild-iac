<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.2 |
| aws | 3.74.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 3.74.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.www](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/route53_record) | resource |
| [aws_route53_zone.primary](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.website_bucket](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/s3_bucket) | resource |
| [aws_iam_policy_document.website_policy](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_name | armazena o nome do dominio | `string` | n/a | yes |
| tags\_validation | Faz a validacao de tags | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->