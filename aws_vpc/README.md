<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.2 |
| aws | 3.74.1 |

## Providers

| Name | Version |
|------|---------|
| aws | 4.15.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.my_private_subnets](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/subnet) | resource |
| [aws_subnet.my_public_subnets](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/subnet) | resource |
| [aws_vpc.my_vpc](https://registry.terraform.io/providers/hashicorp/aws/3.74.1/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cidr\_vpc | teste | `string` | `"10.0.0.0/20"` | no |
| private\_subnet\_numbers | teste | `map(string)` | <pre>{<br>  "us-east-1a": 4,<br>  "us-east-1b": 5,<br>  "us-east-1c": 6<br>}</pre> | no |
| public\_subnet\_numbers | teste | `map(string)` | <pre>{<br>  "us-east-1a": 1,<br>  "us-east-1b": 2,<br>  "us-east-1c": 3<br>}</pre> | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->