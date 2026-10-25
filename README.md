# Moneipe Infra

Configuración de infraestructura y ambientes para Moneipe.

- `databases/`: archivos Docker Compose de PostgreSQL y MongoDB por ambiente; los volúmenes de datos siguen administrados por Docker.
- [Guía operativa de bases de datos](./databases/README.md): configuración, volúmenes y conexiones.
- `kubernetes/`: manifiestos agrupados por ambiente, con microservicios y datos separados.
- `keycloak-config-cli/kubernetes/instance/`: Keycloak nuevo, PostgreSQL, tema e Ingress para K3s.
- `keycloak-config-cli/kubernetes/overlays/`: realms y Jobs Config CLI por ambiente.
- [Guía operativa de Keycloak](./keycloak-config-cli/README.md): estado, acceso temporal y comandos principales.

Los Compose de Keycloak en `/home/frank/docker/moneipe` son independientes y no se movieron. No detenerlos ni modificarlos desde este repositorio. No subir secretos, contraseñas, tokens ni datos personales.
