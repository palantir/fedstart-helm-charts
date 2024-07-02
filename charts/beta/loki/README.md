# loki

A Palantir Fedstart compliant helm-chart for [loki](https://github.com/grafana/loki), deployed in [simple-scalable](https://grafana.com/docs/loki/latest/get-started/deployment-modes/#simple-scalable) mode using Amazon S3 as storage.

## Configuration

Refer to the Loki [documentation](https://grafana.com/docs/loki/next/setup/install/helm/reference/) or the sub-chart [values.yaml](https://github.com/grafana/loki/blob/main/production/helm/loki/values.yaml) for all available upstream configuration options

### Pre-requisites

In order to deploy this helm-chart, a few pre-requisites must be satisfied:

1. An Amazon S3 bucket must exist to store the Loki data files
2. Access configured for the loki service account to the S3 bucket

### Config Overrides

The following config overrides must be applied to Loki when installing for the first time:

```yaml
6.2.0004:
  overrides:
    fedstart:
      s3:
        aws_role_arn: "arn:aws:iam::<account-number>:role/fedstart-default-role"
    loki:
      loki:
        storage:
          s3:
            region: <region>      # us-gov-west-1
          bucketNames:
            chunks: <bucket-name> # loki-bucket
            ruler: <bucket-name>  # loki-bucket
```
