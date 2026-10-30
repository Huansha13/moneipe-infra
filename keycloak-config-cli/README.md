# Keycloak de Moneipe en K3s

## Estado y límites

- Keycloak 26.5.5 y PostgreSQL 16 corren en `moneipe-keycloak`.
- PostgreSQL usa un PVC `local-path` de 5 GiB en el disco del servidor. No borres el PVC; prepara backups.
- El tema `theme-moneipe` está en `kubernetes/keycloak/theme-moneipe/`.
- Los realms se configuran por ambiente con Config CLI: `moneipe-dev`, `moneipe-qa`, `moneipe-prd`.
- El Keycloak Docker de `/home/frank/docker/moneipe` es independiente: no modificarlo ni detenerlo.
- No guardar secretos, usuarios reales ni archivos `.env` en Git.

## Dominios dev

- `auth-moneipe-k3-dev.huansha.win`: login OIDC del frontend.
- `https://moneipe.vercel.app`: origen y URI de retorno autorizados para `moneipe-frontend` en `moneipe-dev`.
- La consola administrativa no tiene hostname público separado; administrarla por `port-forward` + SSH.
- `api-moneipe-k3-dev.huansha.win`: reservado para el API Gateway.
- Tunnel → Traefik: `http://192.168.1.113:32109`. No publicar Kubernetes API, Portainer ni PostgreSQL.
- El hostname `auth-...` es público para OIDC; no usarlo para administrar Keycloak. La consola estará accesible solo por el túnel SSH local.

## Comandos frecuentes

Ver estado:

```bash
sudo k3s kubectl -n moneipe-keycloak get pods,services,pvc,ingress
```

Aplicar Keycloak, el tema y el Ingress:

```bash
sudo k3s kubectl apply -k /home/frank/moneipe-app/infra/keycloak-config-cli/kubernetes/keycloak
sudo k3s kubectl -n moneipe-keycloak rollout status deployment/keycloak --timeout=300s
```

en terminal de mac para acceder por port-forward
```bash
sudo k3s kubectl -n moneipe-keycloak port-forward svc/keycloak 18080:8080
```

Acceso temporal a la consola: ejecuta `kubectl port-forward svc/keycloak 18080:8080` en el servidor y `ssh -N -L 18080:127.0.0.1:18080 frank@192.168.1.113` en el Mac; abre `http://127.0.0.1:18080`. Cerrar los túneles no detiene Keycloak.

El overlay dev configura `moneipe-dev` y el tema. Antes de ejecutar su Job, confirma el Secret `keycloak-config-cli-admin`; el JSON no importa usuarios. QA y PRD necesitan sus dominios y revisión antes de aplicarse.

Para actualizar el realm dev después de cambiar su JSON, elimina el Job anterior si existe y vuelve a crearlo:

```bash
sudo k3s kubectl -n moneipe-keycloak delete job keycloak-config-cli-dev --ignore-not-found
sudo k3s kubectl apply -k /home/frank/moneipe-app/infra/keycloak-config-cli/kubernetes/overlays/dev
sudo k3s kubectl -n moneipe-keycloak wait --for=condition=complete job/keycloak-config-cli-dev --timeout=10m
sudo k3s kubectl -n moneipe-keycloak logs job/keycloak-config-cli-dev
```
