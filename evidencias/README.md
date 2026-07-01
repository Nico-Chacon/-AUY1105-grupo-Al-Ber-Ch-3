# Evidencias - Evaluación Parcial 3

En esta carpeta debes guardar, **por escenario**, los archivos de salida estándar (.txt)
generados con `> nombre_comando.txt` o `tee nombre_comando.txt` para cada comando ejecutado.

Estructura sugerida:

```
evidencias/
├── escenario1/
│   ├── 01-terraform-plan-sin-estado.txt
│   ├── 02-terraform-state-import-vpc.txt
│   ├── 03-terraform-state-import-subnet.txt
│   ├── 04-terraform-state-import-igw.txt
│   ├── 05-terraform-state-import-rt.txt
│   ├── 06-terraform-state-import-rta.txt
│   ├── 07-terraform-state-import-sg.txt
│   ├── 08-terraform-state-import-ec2.txt
│   ├── 09-terraform-state-list.txt
│   ├── 10-terraform-state-show.txt
│   └── 11-terraform-plan-final.txt
├── escenario2/
│   ├── 01-terraform-plan-drift.txt
│   ├── 02-terraform-refresh.txt
│   ├── 03-terraform-plan-post-refresh.txt
│   ├── 04-terraform-taint.txt
│   ├── 05-terraform-plan-taint.txt
│   ├── 06-terraform-apply-taint.txt
│   ├── 07-terraform-untaint.txt
│   └── 08-terraform-plan-final.txt
└── escenario3/
    ├── 01-terraform-state-list.txt
    ├── 02-terraform-state-rm-sg.txt
    ├── 03-terraform-state-list-post-rm.txt
    ├── 04-aws-describe-security-groups.txt
    └── 05-terraform-plan-final.txt
```

