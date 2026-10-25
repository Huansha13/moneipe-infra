# Manifiestos Kubernetes de Moneipe (GitOps)

Organizados por **componente** (db, api-gateway, control-gastos, ...) y, dentro de cada uno, por **ambiente** (dev, qa, prd).

```
kubernetes/
├── db/
│   ├── dev/db-gastos.yaml
│   ├── qa/   (pendiente)
│   └── prd/  (pendiente)
├── api-gateway/
│   ├── dev/api-gateway.yaml
│   ├── qa/
│   └── prd/
└── control-gastos/
    ├── dev/ms-control-gastos.yaml
    ├── qa/
    └── prd/
```

Aplicar un componente en un ambiente:
```bash
sudo k3s kubectl apply -f kubernetes/db/dev/
sudo k3s kubectl apply -f kubernetes/api-gateway/dev/
sudo k3s kubectl apply -f kubernetes/control-gastos/dev/
```

Aplicar TODO un ambiente (varios -f):
```bash
sudo k3s kubectl apply -f kubernetes/db/dev/   -f kubernetes/api-gateway/dev/   -f kubernetes/control-gastos/dev/
```
