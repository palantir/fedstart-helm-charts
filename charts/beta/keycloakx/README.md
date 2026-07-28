# Keycloakx

A Palantir Fedstart compliant helm-chart that
configures [Keycloakx](https://github.com/codecentric/helm-charts/tree/master/charts/keycloakx).

## Configuration

> Refer to the keycloakx [README](https://github.com/codecentric/helm-charts/tree/master/charts/keycloakx#configuration) for all
> available upstream configuration options

Requirements:

- Keycloakx in a highly available configuration uses an external PostgreSQL database.
- An Apollo secret named `keycloakdb` with:
  - key `rdspassword` containing the database password
- An apollo secret named `keycloakadmin` with:
  - key `KC_BOOTSTRAP_ADMIN_USERNAME` containing the keycloak admin username
  - key `KC_BOOTSTRAP_ADMIN_PASSWORD` containing the keycloak admin password

## Sample Apollo Configuration Overrides

```yml
7.2.2001:
  overrides:
    global:
      fedstart:
        hostname: "https://<your-domain>.palantirfedstart.com"
        contextPath: '/auth'
        domainAlias: DEFAULT
    keycloakx:
      # Override if using mirrored container images
      image:
        repository: 1234.dkr.ecr-fips.us-gov-west-1.amazonaws.com
        tag: "26.6.4"
      # Set the admin user password using an existing secret
      extraEnvFrom: |
        - secretRef:
            name: "{{ preprocess .Values.apollo.secrets.keycloakadmin.k8sSecretName }}"
      # Configure the external DB connection settings using an existing secret
      database:
        hostname: "example.us-gov-west-1.rds.amazonaws.com"
        port: 5432
        username: postgres
        existingSecret: "{{ preprocess .Values.apollo.secrets.keycloakdb.k8sSecretName }}"
```

## Accessing the Keycloak Application

By default, Keycloak will be accessible at the `/auth` path on the default frontdoor domain of your FedStart environment.
