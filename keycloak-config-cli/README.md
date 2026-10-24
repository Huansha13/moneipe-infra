# Keycloak Config CLI

Este directorio contiene un ejemplo para aplicar como código el realm `moneipe-dev` en una instancia **nueva** de Keycloak del laboratorio K3s.

## Límites de seguridad y alcance

- El Job no se ha ejecutado y no se debe aplicar todavía.
- El destino esperado es el Service interno `keycloak.moneipe-keycloak.svc.cluster.local:8080`, no el Keycloak Docker actual.
- El Keycloak existente (`26.7.0`) permanece intacto. El primer destino de laboratorio debe usar Keycloak `26.5.5`, compatible con la imagen Config CLI `6.5.1-26.5.5` fijada por digest en el Job.
- El realm de desarrollo y su cliente se crean sin usuarios ni secretos de cliente.
- Los `redirectUris` y `webOrigins` están vacíos intencionalmente. El frontend no podrá iniciar sesión hasta agregar el origen exacto que Vercel asigne y volver a importar la configuración.
- No se incluye un manifiesto `Secret`. Antes de ejecutar el Job, debe existir `keycloak-config-cli-admin` en el namespace `moneipe-keycloak`, con claves `KEYCLOAK_USER` y `KEYCLOAK_PASSWORD`. Debe ser una cuenta de servicio dedicada con los permisos mínimos necesarios para crear/actualizar realms y clientes; no usar la cuenta bootstrap ni guardar sus credenciales en Git.

## Archivos

- `realms/moneipe-dev.json`: definición mínima del realm y cliente OIDC público del frontend.
- `kustomization.yaml` y `kubernetes/`: namespace y Job de importación. Kustomize genera el ConfigMap a partir del JSON.

La configuración evita sustituciones de variables. En Keycloak Config CLI estas están deshabilitadas por defecto; habilitarlas solo si un caso real lo necesita y nunca para introducir secretos en el archivo del realm.

## Prerrequisitos antes de ejecutar

1. Crear y verificar una instancia Keycloak independiente en K3s, versión `26.5.5`, en el namespace `moneipe-keycloak`, con un Service llamado `keycloak`.
2. Confirmar respaldos y estrategia de almacenamiento para la instancia nueva.
3. Provisionar el Secret de autenticación fuera de Git.
4. Obtener la URL de Vercel y agregarla de forma explícita a `redirectUris` y `webOrigins` del cliente.
5. Revisar el JSON y el Job; aplicar solo después de autorización explícita.

## Validación local

Desde la raíz del repositorio:

```bash
python3 -m json.tool keycloak-config-cli/realms/moneipe-dev.json
kubectl kustomize keycloak-config-cli
```

Estos comandos solo validan/renderizan los archivos; no consultan ni modifican el clúster.

## Ejecución futura

El Job es de una sola ejecución. Primero deben cumplirse todos los prerrequisitos y existir el Service y el Secret. Entonces:

```bash
kubectl apply -k keycloak-config-cli
kubectl -n moneipe-keycloak wait --for=condition=complete job/keycloak-config-cli-dev --timeout=10m
kubectl -n moneipe-keycloak logs job/keycloak-config-cli-dev
```

Si se vuelve a ejecutar después de cambiar el JSON, eliminar únicamente el Job completado antes de aplicar de nuevo, porque los Jobs no permiten cambiar su plantilla:

```bash
kubectl -n moneipe-keycloak delete job keycloak-config-cli-dev
kubectl apply -k keycloak-config-cli
```

La integración con Argo CD o Flux se definirá después; no configurar sincronización automática de este Job hasta decidir el mecanismo de reejecución y revisión.

## Versiones fijadas

- Keycloak: `26.5.5` para el nuevo laboratorio, a fin de coincidir con la versión de Keycloak para la que se publicó la imagen del CLI seleccionada.
- Config CLI: `6.5.1-26.5.5`, fijada por digest en `kubernetes/job.yaml`.

La versión del CLI fue contrastada con las etiquetas públicas de [Quay](https://quay.io/repository/adorsys/keycloak-config-cli?tab=tags). Volver a comprobar compatibilidad antes de actualizar cualquiera de las dos imágenes.
