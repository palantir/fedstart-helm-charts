# Keycloak

A Palantir Fedstart compliant helm-chart that
configures [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak).

## Image

You will need to mirror the [Keycloak image](https://hub.docker.com/r/bitnami/keycloak/tags) to your private containers registry and update the chart's image reference accordingly.
See the section below for the relevant configuration overrides to do so.

## Configuration

> Refer to the Keycloak [README](https://github.com/bitnami/charts/tree/main/bitnami/keycloak#parameters) for all
> available upstream configuration options

### Database Configuration

| Parameter                         | Description                                                                        | Default  | Notes                                                                                                                                                                                                                                                                                 |
|-----------------------------------|------------------------------------------------------------------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `externalDatabase.existingSecret` | Name of an existing secret resource containing the database credentials            | `secret` | The default value is just a placeholder. You should set this override to the appropriate value depending on the name of your secret.                                                                         |

## Sample Apollo Configuration Overrides

```yaml
21.3.1006:
  overrides:
    keycloak:
      # Set the admin user password using an existing secret
      auth:
        adminUser: admin
        existingSecret: '{{ preprocess .Values.apollo.secrets.keycloakadmin.k8sSecretName }}'
        passwordSecretKey: password

      # Configure the external DB connection settings using an existing secret
      externalDatabase:
        existingSecret: '{{ preprocess .Values.apollo.secrets.keycloakdb.k8sSecretName }}'
        existingSecretDatabaseKey: db
        existingSecretHostKey: host
        existingSecretPasswordKey: password
        existingSecretPortKey: port
        existingSecretUserKey: user
```
