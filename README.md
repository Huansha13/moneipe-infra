# Moneipe infrastructure

Repositorio para manifiestos de infraestructura y configuración declarativa de Moneipe.

## Estado

- `keycloak-config-cli/` contiene un ejemplo inicial para importar la configuración del realm de desarrollo.
- Los manifiestos todavía no se han aplicado al clúster.
- No agregar credenciales, tokens, usuarios ni datos personales al repositorio.
- El Keycloak Docker que ya existe en el servidor queda fuera del alcance de esta configuración.

## Componentes

- [Keycloak Config CLI](./keycloak-config-cli/README.md): Job de una sola ejecución para aplicar la configuración del realm `moneipe-dev`.

El frontend se despliega actualmente en Vercel. Los dominios de Vercel y Keycloak todavía deben confirmarse antes de habilitar los redirect URIs del cliente.
