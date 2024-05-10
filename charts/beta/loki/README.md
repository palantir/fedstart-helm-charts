# loki

A Palantir Fedstart compliant helm-chart for [loki](https://github.com/grafana/loki), deployed in [simple-scalable](https://grafana.com/docs/loki/latest/get-started/deployment-modes/#simple-scalable) mode using Amazon S3 as storage.

## Configuration

Refer to the Loki [documentation](https://grafana.com/docs/loki/next/setup/install/helm/reference/) or the sub-chart [values.yaml](https://github.com/grafana/loki/blob/main/production/helm/loki/values.yaml) for all available upstream configuration options

### Pre-requisites

In order to deploy this helm-chart, a few pre-requisites must be satisfied:

1. An Amazon S3 bucket must exist to store the Loki data files
2. A K8s secret, named `storage-secret`, must exist in the namespace that loki is installed and must contain the following data.

   ```yaml
   apiVersion: v1
   kind: Secret
   data:
     config: <base64-encoded-config>
     credential: <base64-encoded-credential>
   ```

   ```yaml
   # config format
   [default]
   region=<stack-region>
   ```

   ```yaml
   # credential format
   [default]
   aws_access_key_id=<redacted>
   aws_secret_access_key=<redacted>
   ```

### Config Overrides

The following config overrides should be applied to Loki when installing for the first time

```yaml
6.2.0001:
  overrides:
    loki:
      loki:
        storage:
          s3:
            region: <region>      # us-east-1
            endpoint: <endpoint>  # s3-fips.us-east-1.amazonaws.com
          bucketNames:
            chunks: <bucket-name> # loki-bucket
            ruler: <bucket-name>  # loki-bucket
```
