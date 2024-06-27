# Keycloak

A Palantir Fedstart compliant helm-chart that
configures [Keycloak](https://github.com/bitnami/charts/tree/main/bitnami/keycloak).

## Configuration

> Refer to the Grafana [README](./charts/keycloak/README.md#parameters) for all available upstream configuration options

| Parameter                               | Description                                                                                                                           | Default        | Notes                                                                                                                                                                       |
|-----------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------|----------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `httpRelativePath`                      | Path requests to Keycloak are served at                                                                                               | `"/keycloak/"` | Ensure the path you provide ends in '/'                                                                                                                                     |
| `postgresql.enabled`                    | Sets Keycloak to use the included postgresql DB within the cluster                                                                    | `false`        | To more easily ensure your Keycloak deployment is highly available, it's recommended that you use an external RDS instance your Palantir representative can help you create |
| `auth.adminUser`                        | Sets the username for the admin Keycloak user                                                                                         | `admin`        |                                                                                                                                                                             |
| `auth.existingSecret`                   | Specifies the Kubernetes secret name Keycloak will reference to set the admin user password                                           | `admin`        |                                                                                                                                                                             |
| `auth.existingSecretKey` (**Required**) | Sets the key within the Kubernetes secret specified by `auth.existingSecret` that Keycloak will use to access the admin user password | `""`           |                                                                                                                                                                             |
