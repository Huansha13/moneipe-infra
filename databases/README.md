# Bases de datos de Moneipe

Configuraciones Docker Compose de PostgreSQL por ambiente y MongoDB para dev:

```text
databases/
├── postgres/
│   ├── dev/compose.yaml
│   ├── qa/compose.yaml
│   └── prd/compose.yaml
└── mongo/
    └── dev/compose.yaml
```

Las credenciales locales se guardan fuera del repositorio, en
`/home/frank/.config/moneipe/`, agrupadas por servicio:

```text
databases/postgres/dev/
├── admin.env
└── apps/
    ├── gastos.env
    ├── inversiones.env
    └── usuarios.env
databases/mongo/dev/apps/
└── notificaciones.env
keycloak/
├── dev/runtime.env
├── qa/       (vacío hasta configurar QA)
└── prd/      (vacío hasta configurar PRD)
```

Los directorios tienen permisos `700` y los archivos `600`. No copies estos
archivos al repositorio ni compartas su contenido.
El `runtime.env` existente corresponde al Keycloak configurado para dev; las
credenciales de QA y producción no se han creado.
`notificaciones.env` pertenece al cliente Mongo de `ms-notificaciones` y
contiene la configuración local `MONGO_URI` junto con el issuer de Keycloak.
En Kubernetes, `MONGO_URI` se obtiene del Secret `moneipe-notificaciones-mongo`.
El URI del Secret debe usar `mongo-moneipe:27017`; el archivo local conserva
`localhost:27017` para aplicaciones ejecutadas fuera del clúster. El Service
headless `mongo-moneipe` resuelve al gateway de pods `10.42.0.1`.

Cada ambiente PostgreSQL tiene un contenedor y un volumen Docker propios. Mover
estos archivos Compose no mueve los datos: los volúmenes conservan sus nombres
explícitos (`db-moneipe-data`, `db-moneipe-qa-data` y
`db-moneipe-prd-data`). MongoDB conserva el volumen `db-moneipe-mongodata`.
El Compose de MongoDB requiere `MONGO_PASSWORD`; proporciónala desde el entorno
o un archivo de variables protegido, nunca desde Git.

Cada servidor puede guardar bases separadas por microservicio. Por ejemplo,
Gastos dev usa `moneipe_gastos_dev`; QA y PRD están preparados en estructura,
pero todavía no se han iniciado.

## Estado actual: dev

- Contenedor: `db-moneipe-postgres`
- Puerto para los Pods de K3s: `10.42.0.1:5432`
- Base existente: `moneipe_gastos_dev`
- Usuario de aplicación: `moneipe_dev`
- Volumen persistente: `db-moneipe-data`
- Credenciales: `/home/frank/.config/moneipe/databases/postgres/dev/admin.env` (admin) y `/home/frank/.config/moneipe/databases/postgres/dev/apps/gastos.env` (aplicación), permisos `600`.
- K3s: namespace `moneipe-dev`, Secret `moneipe-gastos-db`.

Levantar o consultar dev:

```bash
docker compose \
  --env-file "$HOME/.config/moneipe/databases/postgres/dev/admin.env" \
  -f /home/frank/moneipe-app/infra/databases/postgres/dev/compose.yaml up -d
docker compose -f /home/frank/moneipe-app/infra/databases/postgres/dev/compose.yaml ps
```

## Conexión del microservicio desde K3s

Los deployments de `ms-control-gastos` y `ms-usuarios` usarán el Service
headless `postgres-moneipe`; el manifiesto de `ms-inversiones` queda preparado
con el mismo nombre DNS.

```text
DB_HOST=postgres-moneipe
DB_PORT=5432
DB_NAME=moneipe_gastos_dev
DB_USER=<desde el Secret moneipe-gastos-db>
DB_PASSWORD=<desde el Secret moneipe-gastos-db>
```

`DB_USER` y `DB_PASSWORD` se guardan en el Secret `moneipe-gastos-db`; refiérelo mediante `secretKeyRef` en el Deployment. No escribas la contraseña en manifiestos versionados. La aplicación Angular no debe conectarse directamente a PostgreSQL.

El Service headless `postgres-moneipe` resuelve al gateway de pods del nodo
(`10.42.0.1:5432`). Se comprobó desde un pod que el acceso directo a esa IP y el
DNS headless funcionan. El antiguo Service con ClusterIP resolvía, pero no
completaba la conexión TCP hacia PostgreSQL publicado en el mismo nodo; por eso
se usa DNS headless. El nombre DNS completo es
`postgres-moneipe.moneipe-dev.svc.cluster.local`.

## QA y producción

- QA tendrá su propio PostgreSQL en el puerto `5433`, volumen `db-moneipe-qa-data` y credencial admin en `/home/frank/.config/moneipe/databases/postgres/qa/admin.env`.
- Producción tendrá su propio PostgreSQL en el puerto `5434`, volumen `db-moneipe-prd-data` y credencial admin en `/home/frank/.config/moneipe/databases/postgres/prd/admin.env`.
- Los comandos Compose deben apuntar al `compose.yaml` de ese ambiente y a su propio archivo de credenciales.

No iniciar QA ni PRD hasta preparar las credenciales y las bases/usuarios de sus microservicios. Las bases de aplicación y usuarios son propios por microservicio y ambiente; no se comparten contraseñas.

El PostgreSQL dev está publicado en `10.42.0.1:5432` y también en
`192.168.1.113:5432`; el último permite conexiones desde la LAN. El acceso local
desde el Mac puede continuar usando el túnel existente hacia
`127.0.0.1:15432`. MongoDB dev se publica en `10.42.0.1:27017`. No publiques
estas bases en Cloudflare Tunnel.

No ejecutes `docker compose down -v`: elimina los datos del volumen asociado.
