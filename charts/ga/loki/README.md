# loki

A Palantir FedStart-compliant Helm chart for [Loki](https://github.com/grafana/loki), deployed in [simple-scalable](https://grafana.com/docs/loki/latest/get-started/deployment-modes/#simple-scalable) mode with Amazon S3 or Azure Blob Storage for object storage.

## Configuration

See the Loki [Helm reference](https://grafana.com/docs/loki/next/setup/install/helm/reference/) or the sub-chart [values.yaml](https://github.com/grafana-community/helm-charts/blob/main/charts/loki/values.yaml) for all upstream options.

## AWS S3

### Prerequisites

1. An S3 bucket for the Loki data.
2. An IAM role granting the `monitoring:loki` service account access to the bucket.

### Override values

```yaml
6.2.0004:
  overrides:
    fedstart:
      s3:
        aws_role_arn: "arn:aws-us-gov:iam::<account-number>:role/observability"
    loki:
      loki:
        storage:
          s3:
            region: <region>
          bucketNames:
            chunks: <bucket-name>
            ruler: <bucket-name>
```

## Azure Blob Storage

Targets Azure Government; see the note below for commercial Azure.

### Prerequisites <!-- markdownlint-disable-line MD024 -->

1. A storage account and blob container for the Loki data.
2. A user-assigned identity granting the `monitoring:loki` service account the **Storage Blob Data Contributor** role on the account.

### Override values <!-- markdownlint-disable-line MD024 -->

```yaml
6.2.0004:
  overrides:
    fedstart:
      azure:
        client_id: <client-id>
        tenant_id: <tenant-id>
    loki:
      loki:
        storage:
          type: azure
          bucketNames:
            chunks: <container-name>
            ruler: <container-name>
          use_thanos_objstore: true
          object_store:
            type: azure
            azure:
              account_name: <storage-account>
              endpoint_suffix: blob.core.usgovcloudapi.net
              use_federated_token: true
        compactor:
          delete_request_store: azure
        schemaConfig:
          configs:
            - from: "2024-04-01"
              store: tsdb
              object_store: azure
              schema: v13
              index:
                prefix: loki_index_
                period: 24h
```
