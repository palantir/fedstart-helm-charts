# vector-aggregator

A Palantir Fedstart compliant helm-chart that configures [vector](https://github.com/vectordotdev/vector) as an aggregator which will source logs from an upstream vector daemon.

## Configuration

Refer to the Vector [README](https://github.com/vectordotdev/helm-charts/tree/develop/charts/vector#all-configuration-options) for all available upstream configuration options

### Config Overrides

This is an example configuration showing how to forward kube pod logs to your loki gateway service and configure the searchable labels.

```yaml
  overrides:
    vector:
      # -- (optional) use container image from a mirrored registry
      #image:
      #  repository: example.dkr.ecr-fips.us-east-1.amazonaws.com/timberio/vector

      # -- Set destinations for the logs (see https://vector.dev/docs/reference/configuration/sinks/)
      sinks:
        # -- Forward logs to loki
        loki:
          type: loki
          out_of_order_action: accept
          encoding:
            codec: json
          # -- The source inputs from transforms or raw 'in.kube-pods'
          inputs:
            - in.kube-pods
          # -- Searchable labels that will be available in grafana
          # -- (see https://grafana.com/docs/loki/latest/get-started/labels/bp-labels/)
          labels:
            k8s_namespace: "{{ kubernetes.pod_namespace }}"
            k8s_pod_name: "{{ kubernetes.pod_name }}"
            k8s_container_name: "{{ kubernetes.container_name }}"
            apollo_entity_id: "{{ .palantir.apolloEntityId }}"
          # -- The loki gateway domain name
          endpoint: https://loki-gateway.<monitoring-namespace>.svc.cluster.local
          tls:
            ca_file: /etc/ssl/rubix-ca/ca.pem
            crt_file: /mnt/secrets/certs/tls.crt
            key_file: /mnt/secrets/certs/tls.key
```

Note: make sure to replace the `<monitoring-namespace>` in the loki endpoint with the namespace where you installed loki.
