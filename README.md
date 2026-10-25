# Moneipe Infra

Manifiestos de Kubernetes y configuración de ambientes para Moneipe.

- `keycloak-config-cli/kubernetes/instance/`: Keycloak nuevo, PostgreSQL, tema e Ingress para K3s.
- `keycloak-config-cli/kubernetes/overlays/`: realms y Jobs Config CLI por ambiente.
- [Guía operativa de Keycloak](./keycloak-config-cli/README.md): estado, acceso temporal y comandos principales.

El Keycloak Docker en `/home/frank/docker/moneipe` es independiente: no detenerlo ni modificarlo desde este repositorio. No subir secretos, contraseñas, tokens ni datos personales.
