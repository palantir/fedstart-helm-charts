# Fedstart Helm Charts

This repository provides reference implementations of open source helm charts with configurations that will work in Palantir's Fedstart environments. These helm chart configurations are intended to work in environments where cluster wide permissions are heavily restricted and/or unavailable.

## Repository Organization

Each reference Helm Chart in this repository is organized under the `charts/<name of helm chart>` directory. Each of these helm charts is structured to have an base chart that contains the Palantir Fedstart specific values.yaml configurations, with the open source chart referenced as a subchart.

Each Helm chart subdirectory should include the LICENSE of the original open source helm chart.

## Versioning

This repository uses chart specific labels to tag versions of each chart. The label structure should following the following convention: `<chart-name>/v<oss-version-number><fedstart-version-number>`. Ex: `prometheus/v25.10.3002`, where:

* `chart-name` is the name of the Helm Chart, and matches the `charts/<chart-name>` subdirectory. Ie: `prometheus`
* `oss-version-number` is the Chart version number in the open source subchart; ie., the `version` found in `charts/prometheus/charts/prometheus/Chart.yaml`
* `fedstart-version-number` is the version associated with the version of the outer chart found in `charts/<chart-name>` and should be the `version` found in the `chart/<chart-name>/Chart.yaml`. This number should be represented as a monotonically increasing integer with at most 3 digits of padding. The digits used for this version will be reduced if the `<oss-version-number>` uses more than one digit, such that the `<oss-version-number><fedstart-version-number>` portion is always exactly 4 digits.
