<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.2.2 |
| aws | 3.74.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| website | ./s3_website | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| domain\_name | armazena o nome do dominio | `string` | n/a | yes |
| region | Variavel que armazena a regiao default | `string` | n/a | yes |
| tag\_departamento | Departamento para o qual sera criado o site. Valores aceitos = Marketing, RH, Financeiro & TI. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->