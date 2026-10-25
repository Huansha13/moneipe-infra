# Moneipe Infra

Configuración de infraestructura y ambientes para Moneipe.

- `keycloak-config-cli/kubernetes/instance/`: Keycloak nuevo, PostgreSQL, tema e Ingress para K3s.
- `keycloak-config-cli/kubernetes/overlays/`: realms y Jobs Config CLI por ambiente.
- [Guía operativa de Keycloak](./keycloak-config-cli/README.md): estado, acceso temporal y comandos principales.

El Keycloak y las bases Docker existentes en `/home/frank/docker/moneipe` son independientes: no detenerlos ni modificarlos desde este repositorio. No subir secretos, contraseñas, tokens ni datos personales.
