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

## Trabajar con GitHub Codespaces (recomendado para esta evaluación)

Este repositorio incluye `.devcontainer/devcontainer.json`, que prepara automáticamente
un Codespace con **Terraform** y **AWS CLI** ya instalados (no necesitas instalarlos
manualmente).

### 1. Nunca subas credenciales al repositorio

Antes de tocar código, verifica que **nunca** se commitee:

- `terraform.tfstate`, `terraform.tfstate.backup`, `*.tfvars` (ya están en `.gitignore`)
- `~/.aws/credentials` o cualquier archivo con `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY`
- El archivo `.pem` de tu Key Pair

Las credenciales de AWS se inyectan como **secrets**, nunca escritas en archivos del repo.

### 2. Configurar los secrets en GitHub (antes de abrir el Codespace)

Necesitas **dos lugares distintos** de secrets (son independientes entre sí):

**A) Codespaces secrets** → para que Terraform tenga credenciales dentro del Codespace:
`Repositorio → Settings → Secrets and variables → Codespaces → New repository secret`

Crea:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_SESSION_TOKEN` (obligatorio si usas AWS Academy / Learner Lab; sus credenciales
  son temporales y **expiran cada 3-4 horas**, deberás actualizar este secret cada vez
  que reinicies el laboratorio de AWS Academy)

**B) Actions secrets** → para que el pipeline de CI pueda ejecutar `terraform plan`:
`Repositorio → Settings → Secrets and variables → Actions → New repository secret`

Crea los mismos tres secrets con los mismos nombres.

> Terraform y la AWS CLI leen automáticamente las variables de entorno
> `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` y `AWS_SESSION_TOKEN`. Por eso, dentro del
> Codespace **no necesitas ejecutar `aws configure`** (evita crear un archivo de
> credenciales en disco).

### 3. Abrir el Codespace

`Code → Codespaces → Create codespace on main`

Al terminar de construirse, verifica:

```bash
terraform -version
aws --version
aws sts get-caller-identity
```

Si el último comando devuelve tu cuenta/rol de AWS, los secrets están bien configurados.

### 4. Tu IP pública dentro de un Codespace

Un Codespace corre en la nube de GitHub/Azure, **no en tu computador**. Si vas a
conectarte por SSH a la EC2 desde el propio Codespace, usa la IP de salida del
Codespace:

```bash
curl -s https://checkip.amazonaws.com
```

Si en cambio te conectarás por SSH desde tu notebook, usa la IP pública de tu notebook
(la misma URL, ejecutada desde tu terminal local, no desde el Codespace).

### 5. Antes de cada `git push`

```bash
git status                 # confirma que NO aparezcan .tfstate, .tfvars ni credenciales
terraform -chdir=infra fmt # formatea el código
```


`.github/workflows/deploy.yml` ejecuta en cada push/PR a `main`:

1. `terraform fmt -check` y `terraform validate`
2. `tflint`
3. `checkov` (modo `soft_fail`, no bloquea el pipeline)
4. Generación de plan en JSON + evaluación con **OPA** contra `policies/security.rego`

> Nota: el paso "Configure AWS Credentials" usa los **Actions secrets** configurados en
> el punto anterior. Si el `AWS_SESSION_TOKEN` de AWS Academy expiró, este paso fallará
> con un error de autenticación esperado — actualiza el secret y vuelve a ejecutar el
> workflow (`Actions → workflow → Re-run jobs`).
