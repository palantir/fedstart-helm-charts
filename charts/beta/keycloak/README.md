# Keycloak

A Palantir Fedstart compliant helm-chart that
configures [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak).

## Accessing the Keycloak Application

By default, Keycloak will be accessible at the `/keycloak` path on the default frontdoor domain of your FedStart environment.

## Configuration

> Refer to the Keycloak [README](https://github.com/bitnami/charts/tree/main/bitnami/keycloak#parameters) for all
> available upstream configuration options

### Prerequisites

In order to deploy this Helm chart, a few prerequisites must be satisfied:

1. An external PostgreSQL Database instance for use as the backing store of your Keycloak instance provisioned.
2. An Apollo secret containing the connection configuration for your external Postgresql Database created.
   1. See the [External Database Configuration](#external-database-configuration) section below for details on creating this secret.
3. An Apollo secret containing the password for the Keycloak admin user under the key `password` created.
   1. The admin user username is set as `admin` by default.
4. The [Keycloak image](https://hub.docker.com/r/bitnami/keycloak/tags) mirrored to your private containers registry and the chart's image reference updated accordingly.
See the [example configuration overrides](#sample-apollo-configuration-overrides) below for the relevant configuration overrides to do so.

### External Database Configuration

| Parameter                         | Description                                                             | Default  | Notes                                                                                                                                |
|-----------------------------------|-------------------------------------------------------------------------|----------|--------------------------------------------------------------------------------------------------------------------------------------|
| `externalDatabase.existingSecret` | Name of an existing secret resource containing the database credentials | `secret` | The default value is just a placeholder. You should set this override to the appropriate value depending on the name of your secret. |

The Apollo secret specified by `externalDatabase.existingSecret` should contain the following key, value pairs:

| Key        | Value                                       |
|------------|---------------------------------------------|
| `db`       | Name of database you are using for Keycloak |
| `host`     | Database endpoint                           |
| `port`     | Database ingress port                       |
| `user`     | Database user username                      |
| `password` | Database user password                      |

## Sample Apollo Configuration Overrides

```yaml
21.3.1006:
  overrides:
    keycloak:
      image:
        registry: 1234.dkr.ecr-fips.us-gov-west-1.amazonaws.com
        repository: charts/keycloak
        tag: 24.0.4-debian-12-r1
         
      # Set the admin user password using an existing secret
      auth:
        existingSecret: '{{ preprocess .Values.apollo.secrets.keycloakadmin.k8sSecretName }}'

      # Configure the external DB connection settings using an existing secret
      externalDatabase:
        existingSecret: '{{ preprocess .Values.apollo.secrets.keycloakdb.k8sSecretName }}'
```
