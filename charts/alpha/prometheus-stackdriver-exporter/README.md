# Prometheus Stackdriver Exporter

A Palantir Fedstart compliant helm-chart that configures [prometheus-stackdriver-exporter](https://github.com/prometheus-community/stackdriver_exporter) for monitoring Google Cloud Platform metrics.

## Configuration

To configure this reference helm chart, you must substitute the following parameters:

- `__REPLACE_ME_PROJECT_ID`: The GCP project ID.
- `__REPLACE_ME_GCP_SERVICE_ACCOUNT_CREDENTIALS_CONFIGMAP`: The name of the GCP configmap which contains your `credentials.json` file.

Review FedStart docs for how to configure this within your FedStart environment.

## Additional Configuration

Refer to the prometheus-stackdriver-exporter [values.yaml](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-stackdriver-exporter/values.yaml) file for all available upstream configuration options
