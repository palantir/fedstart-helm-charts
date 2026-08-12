# loki

A Palantir FedStart-compliant Helm chart for [Loki](https://github.com/grafana/loki), deployed in [simple-scalable](https://grafana.com/docs/loki/latest/get-started/deployment-modes/#simple-scalable) mode with Amazon S3 (default) or Azure Blob Storage for object storage.

## Configuration

See the Loki [Helm reference](https://grafana.com/docs/loki/next/setup/install/helm/reference/) or the sub-chart [values.yaml](https://github.com/grafana-community/helm-charts/blob/main/charts/loki/values.yaml) for all upstream options.

Object storage authentication is keyless in both clouds, via OIDC federation on the `monitoring:loki` service account: the pod's default ServiceAccount token is exchanged for cloud credentials — no static keys and no workload-identity webhook. The IAM role (AWS) or user-assigned identity (Azure) and its federated credential are provisioned separately (e.g. the observability OIDC-roles module).

## AWS S3

### Prerequisites

1. An S3 bucket for the Loki data.
2. An IAM role granting the `monitoring:loki` service account access to the bucket.

### Override values

```yaml
fedstart:
  s3:
    aws_role_arn: "arn:aws-us-gov:iam::<account>:role/observability"
loki:
  loki:
    storage:
      s3:
        region: us-gov-west-1
      bucketNames:
        chunks: <bucket-name>
        ruler: <bucket-name>
```

## Azure Blob Storage

Targets Azure Government; see the note below for commercial Azure.

### Prerequisites

1. A storage account and blob container for the Loki data.
2. A user-assigned identity granting the `monitoring:loki` service account the **Storage Blob Data Contributor** role on the account.

### Override values

Start from [`values-azure.yaml`](./values-azure.yaml) and fill in the `__REPLACE_ME_*` placeholders:

```yaml
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
