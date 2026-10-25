# Manifiestos Kubernetes de Moneipe (GitOps)

Organizados primero por **ambiente**, luego por tipo de recurso y microservicio:

```text
kubernetes/
├── dev/
│   ├── kustomization.yaml
│   ├── data/mongo-moneipe.yaml
│   ├── data/postgres-moneipe.yaml
│   └── ms/
│       ├── api-gateway/api-gateway.yaml
│       ├── control-gastos/ms-control-gastos.yaml
│       ├── inversiones/ms-inversiones.yaml
│       ├── notificaciones/ms-notificaciones.yaml
│       └── usuarios/ms-usuarios.yaml
├── qa/
│   ├── data/
│   └── ms/
└── prd/
    ├── data/
    └── ms/
```

Flux reconcilia `./kubernetes/dev`. La Kustomization de `dev` conserva el conjunto
de recursos existentes de `api-gateway` y `ms-control-gastos`, y agrega
`ms-usuarios` a la reconciliación. La configuración de PostgreSQL se publica
como `postgres-moneipe`, un Service headless cuyo DNS resuelve directamente al
gateway de pods `10.42.0.1`; así se evita el ClusterIP, que no pudo alcanzar el
PostgreSQL publicado en el mismo nodo.
MongoDB externo también se publica como el Service headless `mongo-moneipe`,
que resuelve al mismo gateway de pods en el puerto `27017`. El `MONGO_URI`
confidencial de `ms-notificaciones` se guarda en el Secret
`moneipe-notificaciones-mongo`, no en este repositorio.
Al cambiar ese Secret, incrementa `moneipe.dev/mongo-uri-revision` en el
Deployment para que Flux cree pods nuevos que lean las variables actualizadas.

Los manifiestos de `inversiones` y `notificaciones` permanecen ordenados en
`dev/ms/`, pero no se agregan automáticamente al despliegue hasta incluirlos
explícitamente en `kubernetes/dev/kustomization.yaml`.

Validar y aplicar el conjunto administrado de `dev`:

```bash
kubectl kustomize infra/kubernetes/dev
sudo k3s kubectl apply -k infra/kubernetes/dev
```

Aplicar manualmente un microservicio individual:

```bash
sudo k3s kubectl apply -f infra/kubernetes/dev/ms/control-gastos/
```

La reorganización no mueve ni modifica las bases de datos Docker. El Service
anterior `db-gastos` se reemplaza por `postgres-moneipe`; Flux eliminará los
recursos antiguos al reconciliar la nueva Kustomization.
