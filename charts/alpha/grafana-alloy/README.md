# Grafana Agent

A Palantir Fedstart compliant helm-chart that configures [grafana-alloy](https://github.com/grafana/alloy).

## Configuration

Refer to the upstream Grafana documentation for alloy [here](https://grafana.com/docs/alloy/latest/configure/kubernetes/) for all available upstream configuration options. Further information on alloy can also be found at the source repo [README](https://github.com/grafana/alloy/blob/main/README.md).

### Defaults

Alloy in this helm chart has been configured with the following important defaults:
- Runs as a deployment: alloy can be run as a stateful-set, deployment, or daemonset. This helm chart deploys allow as a deployment. This is overridden by the `alloy.controller.type` field.
- Replicas: the deployment is given a single replica.
- Collection: this deployment configures alloy to scrape it's own pods for metrics.
- Config-reloader: the config-reloader shipped with alloy is enabled.

### Collection Config

Grafana alloy typically receives configuration via a config map. You can deploy a config map independently of this helm chart, or you may also provide an override to the alloy helm-chart to create it's own config-map, as shown below.

```yaml
  overrides:
    alloy:
      alloy:
        configMap:
          create: true
          content: |-
            discovery.kubernetes "alloy_pods" {
              role = "pod"
              namespaces {
                names = ["my_collection_namespace"]
              }
              selectors {
                role = "pod"
                label = "app.kubernetes.io/name=my_application"
              }
            }

            ...

```

Note: replace `my_collection_namespace` with the namespace in which your applications are deployed, and my `my_application` with the label in the kubernetes manifest of your application pod.
