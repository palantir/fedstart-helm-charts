# Grafana

A Palantir Fedstart compliant helm-chart that configures [Grafana](https://github.com/grafana/grafana).

High availability Grafana in FedStart requires using an external database for Grafana configuration, dashboards, etc.  Contact your Palantir representative to setup a postgres RDS instance for Grafana.

## Configuration

In Apollo create the following secrets:

- secret named `admincreds` with the following key/value pairs:
  - `admin-user` : `<desired username for admin user>`
  - `admin-password` : `<desired password for admin user>`
- secret named `dbcreds` with the following key/value pairs:
  - `GF_DATABASE_USER` : `<RDS database username>`
  - `GF_DATABASE_PASSWORD` : `<RDS database password>`

The following are the minimal required configuration overrides:

```yaml
  overrides:
    grafana:
      baseURL: "https://<your-domain>.palantirfedstart.com"
      admin:
        existingSecret: "{{ preprocess .Values.apollo.secrets.admincreds.k8sSecretName }}"
      envFromSecrets:
        - name: "{{ preprocess .Values.apollo.secrets.admincreds.k8sSecretName }}"
      grafana.ini:
        database:
          host: "example.us-gov-west-1.rds.amazonaws.com:5432"
```

> Refer to the Grafana [README](https://github.com/grafana/helm-charts/tree/main/charts/grafana#configuration) for all available upstream configuration options.

Sample Apollo configuration overrides with loki and prometheus datasources:

```yaml
7.3.7005:
  overrides:
    grafana:
      # -- Overwrite default image registry for mirrored artifacts
      # image:
      #   registry: 12345.dkr.ecr.us-east-1.amazonaws.com
      #   repository: grafana/grafana

      # -- URL where grafana will be accessed from
      baseURL: "https://<your-domain>.palantirfedstart.com"
      # contextPath: "/grafana"

      # Initialize admin user/password from an existing secret
      admin:
        existingSecret: "{{ preprocess .Values.apollo.secrets.admincreds.k8sSecretName }}"

      # Load GF_DATABASE_USER and GF_DATABASE_PASSWORD environment variables from secret
      envFromSecrets:
        - name: "{{ preprocess .Values.apollo.secrets.dbcreds.k8sSecretName }}"

      grafana.ini:
        # -- Configure RDS database for storage of users, dashboards, datasources, etc.
        database:
          host: "example.us-gov-west-1.rds.amazonaws.com:5432"
          # type: postgres
          # name: grafana
          # ssl_mode: require
          # note, database username and password set in environment variables set by secret

      # -- Configure grafana datasources for logs and metrics
      datasources:
        datasources.yaml:
          apiVersion: 1
          datasources:
          - name: Loki
            type: loki
            url: "https://loki-gateway.{{ .Release.Namespace }}.svc.cluster.local:443"
            access: proxy
            isDefault: true
            timeout: 360
            editable: true
            secureJsonData:
              tlsCACert: $__file{/etc/ssl/rubix-ca/ca.pem}
              tlsClientCert: $__file{/mnt/secrets/certs/tls.crt}
              tlsClientKey: $__file{/mnt/secrets/certs/tls.key}
            jsonData:
              tlsAuth: true
              tlsSkipVerify: false
              tlsAuthWithCACert: true
              manageAlerts: false
              # Timeout must be greater than the query timeout in Loki
              timeout: 420
          - name: Prometheus
            type: prometheus
            url: "https://prometheus.{{ .Release.Namespace }}.svc.cluster.local:80"
            access: proxy
            isDefault: false
            timeout: 360
            editable: true
            secureJsonData:
              tlsCACert: $__file{/etc/ssl/rubix-ca/ca.pem}
              tlsClientCert: $__file{/mnt/secrets/certs/tls.crt}
              tlsClientKey: $__file{/mnt/secrets/certs/tls.key}
            jsonData:
              tlsAuth: true
              tlsSkipVerify: false
              tlsAuthWithCACert: true
              manageAlerts: false
              # Timeout must be greater than the query timeout in Loki
              timeout: 420
```
