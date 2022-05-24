# Terraform VPC for AWS

### Esse projeto tem o objetivo de facilitar a criação de uma VPC na AWS com 3 subnets privadas e 3 públicas.

<br>

## ☕ Usando Terraform VPC for AWS

Siga estas etapas para utilizar o projeto:

```
terraform init
```

Definir os seguintes parâmetros em varibles.tfvars:

```
region
vpc_name
cidr_range
```
> Mais informações no arquivo variables.tf

```
terraform apply
```
> Seus recursos serão criados na AWS
