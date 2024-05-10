# Grafana

A Palantir Fedstart compliant helm-chart that configures [Grafana](https://github.com/grafana/grafana).

## Configuration

> Refer to the Grafana [README](https://github.com/grafana/helm-charts/tree/main/charts/grafana#configuration) for all available upstream configuration options

| Parameter            | Description                     | Default     |
|----------------------|---------------------------------|-------------|
| `baseURL`            | URL for grafana  (**required**) | `""`        |
| `contextPath`        | Path for the Grafana server     | `/grafana`  |
