# vector-aggregator

A Palantir Fedstart compliant helm-chart that configures [vector](https://github.com/vectordotdev/vector) as an aggregator which will source logs from an upstream vector daemon.

## Configuration

Refer to the Vector [README](https://github.com/vectordotdev/helm-charts/tree/develop/charts/vector#all-configuration-options) for all available upstream configuration options

### Config Overrides

This is an example configuration intended to show options when configuring vector.

- Transform the kube pod logs, dropping the node_labels and namespace_labels
- Forward the transformed pod logs to loki gateway service and configures searchable labels
- The commented out sections which sample every 100th log message and print it to the vector pod logs which can be useful for debugging.

Make sure to update as appropriate for your use case.

```yaml
  overrides:
    vector:
      # -- Configure vector's log level (useful for debugging)
      # logLevel: 'debug'

      # -- (optional) use the mirrored container registry
      #image:
      #  repository: example.dkr.ecr-fips.us-east-1.amazonaws.com/timberio-vector

      # -- (optional) Configure log transforms (see https://vector.dev/docs/reference/configuration/transforms/)
      transforms:
        # -- Example to sample every 100th log message (useful for debugging)
        # sampled-kube-pods:
        #   type: sample
        #   inputs:
        #     - in.kube-pods
        #   rate: 100

        # -- Drop kubernetes.node_labels and kubernetes.namespace_labels to reduce storage
        kube-pods-json:
          type: remap
          inputs:
            - in.kube-pods
          drop_on_error: false
          drop_on_abort: false
          source: |
            if exists(.kubernetes.node_labels) {
              del(.kubernetes.node_labels)
            }
            if exists(.kubernetes.namespace_labels) {
              del(.kubernetes.namespace_labels)
            }

      # -- Set destinations for the logs (see https://vector.dev/docs/reference/configuration/sinks/)
      sinks:
        # -- write sampled logs to console (useful for debugging)
        #stdout:
        #  type: console
        #  inputs:
        #    - sampled-kube-pods
        #  encoding:
        #    codec: json

        # -- Forward logs to loki
        loki:
          type: loki
          out_of_order_action: accept
          encoding:
            codec: json
          # -- The source inputs from transforms or raw 'in.kube-pods'
          inputs:
            - kube-pods-json
          # -- Searchable labels that will be available in grafana
          # -- (see https://grafana.com/docs/loki/latest/get-started/labels/bp-labels/)
          labels:
            k8s_namespace: "{{ kubernetes.pod_namespace }}"
            k8s_pod_name: "{{ kubernetes.pod_name }}"
            k8s_container_name: "{{ kubernetes.container_name }}"
            apollo_entity_id: "{{ .kubernetes.pod_annotations.\"apollo.palantir.com/metadata.entity.id\" }}"
          # -- The loki gateway domain name
          endpoint: https://loki-gateway.<monitoring-namespace>.svc.cluster.local
          tls:
            ca_file: /etc/ssl/rubix-ca/ca.pem
            crt_file: /mnt/secrets/certs/tls.crt
            key_file: /mnt/secrets/certs/tls.key
```

Note: make sure to replace the `<monitoring-namespace>` in the loki endpoint with the namespace where you installed loki.

Sample override to ingest from cloudtrail:

```yaml
  overrides:
    vector:
      sources:
        daemonset:
          enabled: false
        cloudtrail:
          enabled: true
          region: us-gov-west-1
          sqs_url: https://sqs.us-gov-west-1.amazonaws.com/ACCOUNT/SQSNAME
          cloudtrail_role_arn: CLOUDTRAIL_ROLE_ARN
      transforms:
        flatten-cloudtrail:
          type: remap
          inputs:
            - cloudtrail
          drop_on_error: false
          drop_on_abort: false
          source: |
            . = .Records
        # -- For simplicity, we didn't include daemonset source here so removing the `in` transform.
        in: null
      sinks:
        # -- Forward logs to loki
        loki:
          type: loki
          out_of_order_action: accept
          encoding:
            codec: json
          inputs:
            - flatten-cloudtrail
          # -- Searchable labels that will be available in grafana
          # -- (see https://grafana.com/docs/loki/latest/get-started/labels/bp-labels/)
          labels:
            aws_region: "{{ awsRegion }}"
            event_category: "{{ eventCategory }}"
            event_source: "{{ eventSource }}"
            event_type: "{{ eventType }}"
          # -- The loki gateway domain name
          endpoint: https://loki-gateway.<monitoring-namespace>.svc.cluster.local
          tls:
            ca_file: /etc/ssl/rubix-ca/ca.pem
            crt_file: /mnt/secrets/certs/tls.crt
            key_file: /mnt/secrets/certs/tls.key
```
