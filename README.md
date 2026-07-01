[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D%201.5.0-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS Provider](https://img.shields.io/badge/AWS%20Provider-~%3E%206.0-FF9900?logo=amazon-aws)](https://registry.terraform.io/providers/hashicorp/aws/latest)
[![Licencia](https://img.shields.io/badge/Licencia-GPLv3-blue)](LICENSE.txt)
![Demo del módulo](hi-hello.gif)

# Prueba Nº3 - Alvarez, Berardinucci y Chacón

## Info
Este repositorio continúa el trabajo de:
https://github.com/Nico-Chacon/AUY1105-grupo-Al-Ber-Ch

Corresponde a la **Evaluación Parcial N°3** de AUY1105 - Infraestructura como código II:
gestión avanzada de recursos de Terraform (recuperación de estado, refresh/taint/untaint,
y desasociación de recursos del estado).

## Descripción
Módulo de Terraform que despliega, de forma modular, una infraestructura base en AWS:

- **modules/redes**: VPC, subred pública, Internet Gateway, Route Table + asociación, y
  Security Group (SSH restringido a una IP autorizada).
- **modules/computo**: instancia EC2 (con IMDSv2 forzado, monitoreo activado y disco
  raíz cifrado), conectada a la subred y al Security Group del módulo de redes.
- **infra/**: root module que orquesta ambos módulos y expone los outputs consolidados.

## Estructura del repositorio

```
.
├── infra/                 # Root module (aquí se ejecuta terraform init/plan/apply)
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── versions.tf
├── modules/
│   ├── redes/              # VPC, subnet, IGW, route table, security group
│   └── computo/            # Instancia EC2
├── examples/               # Ejemplos de uso independiente de cada módulo
├── policies/security.rego  # Reglas OPA (SSH abierto, tipo de instancia)
├── evidencias/             # Salidas de consola (.txt) por escenario (ver evidencias/README.md)
└── .github/workflows/      # Pipeline de calidad y seguridad (fmt, validate, tflint, checkov, OPA)
```

## Requisitos previos

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configurado (`aws configure`)
- Credenciales de AWS Academy / AWS con permisos sobre EC2, VPC.
- Un **Key Pair** ya creado en la región de trabajo (por defecto `us-east-1`).

## Uso rápido

```bash
cd infra
terraform init
terraform plan
terraform apply
```

Antes de aplicar, edita `infra/variables.tf` (o crea un `terraform.tfvars`, no versionado)
y ajusta al menos:

- `my_ip`: tu IP pública actual en formato `x.x.x.x/32` (obtenla con
  `curl -s https://checkip.amazonaws.com`).
- `ami_id`: una AMI vigente en tu región (verifica en la consola de EC2 o con
  `aws ec2 describe-images`).
- `key_name`: el nombre de un Key Pair existente en tu cuenta/región.

## Parámetros principales (root module)

| Variable            | Descripción                                   | Default            |
|---------------------|------------------------------------------------|---------------------|
| `region`            | Región AWS                                     | `us-east-1`          |
| `vpc_cidr`          | CIDR de la VPC                                 | `10.1.0.0/16`         |
| `subnet_cidr`       | CIDR de la subred pública                      | `10.1.1.0/24`         |
| `availability_zone` | Zona de disponibilidad                         | `us-east-1a`          |
| `my_ip`             | IP autorizada para SSH (`/32`)                 | *(reemplazar)*        |
| `ami_id`            | AMI de la instancia EC2                        | *(reemplazar)*        |
| `instance_type`     | Tipo de instancia (política OPA exige t2.micro)| `t2.micro`             |
| `key_name`          | Key Pair para acceso SSH                       | `ec2-key-1`            |

## Outputs

- `vpc_id`, `subnet_id`, `sg_id`, `igw_id`, `route_table_id`
- `instance_id`, `instance_ip`

## Evaluación Parcial N°3 - Escenarios trabajados

1. **Recuperación del estado de Terraform**: eliminación simulada de `terraform.tfstate`
   y reconstrucción completa mediante `terraform state import` para cada recurso.
2. **Actualización y reforzamiento de recursos**: detección de drift manual vía consola
   AWS, sincronización con `terraform refresh`, y recreación controlada de la EC2 con
   `terraform taint` / `terraform untaint`.
3. **Eliminación de recursos del estado**: desasociación del Security Group del estado
   de Terraform (`terraform state rm`) sin eliminar el recurso real en AWS.

El detalle paso a paso, con las capturas de pantalla requeridas, está documentado en el
informe entregado (`Informe_EP3_Terraform.docx` / PDF).

## Pipeline de calidad (CI)

`.github/workflows/deploy.yml` ejecuta en cada push/PR a `main`:

1. `terraform fmt -check` y `terraform validate`
2. `tflint`
3. `checkov` (modo `soft_fail`, no bloquea el pipeline)
4. Generación de plan en JSON + evaluación con **OPA** contra `policies/security.rego`

> Nota: el paso de `terraform plan` en CI requiere credenciales AWS configuradas como
> secrets del repositorio (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`); si no están
> configuradas, ese paso puede fallar de forma esperada y no bloquea el resto del pipeline.
