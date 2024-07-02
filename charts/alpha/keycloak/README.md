# Keycloak

A Palantir Fedstart compliant helm-chart that
configures [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak).

## Configuration

> Refer to the Grafana [README](./charts/keycloak/README.md#parameters) for all available upstream configuration options

### General Configuration

| Parameter                               | Description                                                                       | Default        | Notes                                   |
|-----------------------------------------|-----------------------------------------------------------------------------------|----------------|-----------------------------------------|
| `httpRelativePath`                      | Set the path relative to '/' for serving resources                                | `"/keycloak/"` | Ensure the path you provide ends in `/` |
| `auth.adminUser`                        | Keycloak administrator user                                                       | `admin`        |                                         |
| `auth.existingSecret`                   | Existing secret containing Keycloak admin password                                | `""`           |                                         |
| `auth.passwordSecretKey` (**Required**) | Key where the Keycloak admin password is being stored inside the existing secret. | `""`           |                                         |
| `service.annotations`                   | Additional custom annotations for Keycloak service                                |                |                                         |

### Database Configuration

| Parameter                         | Description                                                                        | Default  | Notes                                                                                                                                                                                                                                                |
|-----------------------------------|------------------------------------------------------------------------------------|----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `postgresql.enabled`              | Switch to true to enable the PostgreSQL helm chart instead of using an external DB | `false`  | To ensure your Keycloak deployment is highly available, it's recommended that you use an external DB instance. Set up this connection using the overrides under the [`externalDatabase`](./charts/keycloak/README.md#database-parameters) parameter. |
| `externalDatabase.existingSecret` | Name of an existing secret resource containing the database credentials            | `secret` | The default value is just a placeholder.                                                                                                                                                                                                             |
