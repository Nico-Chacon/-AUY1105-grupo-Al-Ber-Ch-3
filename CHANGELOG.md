# CHANGELOG

## [3.0.0] - 2026-07-01
### Cambiado (heredado de AUY1105-grupo-Al-Ber-Ch-2, corregido para EP3)
- Se corrigieron inconsistencias de nombres de recursos entre `modules/redes`,
  `modules/computo` y sus respectivos `outputs.tf` (los nombres no coincidían y el
  `terraform plan` fallaba).
- Se eliminaron recursos de VPC/Subnet/SG duplicados que existían directamente en
  `infra/main.tf` además de en `modules/redes` (causaban colisión de recursos).
- Se agregó `data`/variable faltante en `modules/computo` (`data.aws_ami.ubuntu` no
  estaba declarado); se reemplazó por `var.ami_id` explícito para mantener el módulo
  parametrizable.
- Se agregaron outputs faltantes en `modules/redes` (`igw_id`, `route_table_id`).
- Se eliminó del repositorio la carpeta `aws/` (instalador de AWS CLI de ~266 MB
  comiteado por error) y los artefactos generados `infra/plan.out` y
  `infra/terraform.json` (no deben versionarse, se generan localmente).
- Se actualizó `.gitignore` para excluir explícitamente `terraform.json` y `plan.out`
  desde cualquier carpeta.
- Se actualizó el pipeline (`deploy.yml`) con `actions/checkout@v4`,
  `hashicorp/setup-terraform@v3`, `terraform fmt -check` y `terraform init -backend=false`
  antes de `validate`.

### Añadido
- Carpeta `evidencias/` con estructura sugerida para las salidas de consola (.txt) de
  los 3 escenarios de la Evaluación Parcial 3.
- Documentación en `README.md` de los escenarios trabajados en EP3.

---

## Historial heredado (AUY1105-grupo-Al-Ber-Ch-2, EP1/EP2)

## [1.3.0] - 2026-04-28
### Added
- Creación inicial del repositorio AUY1105-grupo-XX
- Añadido README.md con objetivos
- Añadido .gitignore para Terraform
- main.tf con VPC, Subnet, SG y EC2
- variables.tf y outputs.tf para modularidad
- policies/security.rego con reglas OPA
- pipeline.yml con validaciones (TFLint, Checkov, Terraform, OPA)
- Se agregó la Internet Gateway y la Route Table configurada

## [1.0.1] - 2026-04-29
### Added
- Tag `Environment = "dev"` en recurso EC2 dentro de `main.tf`.

## [1.0.2] - 2026-04-29
### Added
- Corrección en `pipeline.yml`.

## [1.1.0] - 2026-04-28
### Añadido
- Mejora en las descripciones de variables para cumplimiento de nomenclatura.
- Actualización de políticas OPA para validación de SSH y tipo de instancia.

## [1.2.0] - 2026-04-28
### Corregido
- **Pipeline:** corrección del error de resolución de versión en TFLint
  (`terraform-linters/setup-tflint@v4`).
- **Seguridad:** flag `--soft-fail` en Checkov.
### Añadido
- Parametrización del tipo de instancia EC2.
- Descripciones detalladas de variables.

## [2.0.0] - 2026-06-04
### Added
- Creación de la carpeta `modules` con subcarpetas `computo` y `redes`.
- Modificación de `infra/main.tf` para orquestar los módulos.

## [2.1.0] - 2026-06-05
### Added
- Modificación en `variables.tf` dentro de `modules/`.
- Actualización en todos los `outputs.tf`.
- Modificación de `pipeline.yml`.
- Ajustes en `computo.tf` y `redes.tf`.

## [2.1.1] - 2026-06-05
### Added
- Se agregó `hi-hello.gif` a `README.md`.
### Fixed
- Se arregló `variables.tf` dentro de `infra`.
- Se arregló `pipeline.yml`.

## [2.1.2] - 2026-06-05
### Added
- Se tiparon todas las variables en `infra/variables.tf` (`type = string`).
- Se agregaron `description` en reglas de seguridad (SG).
- En EC2: `monitoring = true`, IMDSv2 forzado, ajustes de IP pública.
- Pipeline: trigger `push`/`pull_request`, paso `Terraform Plan (JSON)` para OPA.
