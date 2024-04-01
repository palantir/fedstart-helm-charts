# Fedstart Helm Charts

This repository provides reference implementations of open source helm charts with configurations that will work in Palantir's Fedstart environments. These helm chart configurations are intended to work in environments where cluster wide permissions are heavily restricted and/or unavailable.

## Repository Organization

Each reference Helm Chart in this repository is organized under the `charts/<name of helm chart>` directory. Each of these helm charts is structured to have a base chart that contains the Palantir Fedstart specific values.yaml configurations, with the open source chart referenced as a subchart.

Each Helm chart subdirectory should include the LICENSE of the original open source helm chart.

## Versioning

This repository uses chart specific labels to tag versions of each chart. The label structure should following the following convention: `<chart-name>/v<oss-version-number><fedstart-version-number>`. Ex: `prometheus/v25.10.3002`, where:

* `chart-name` is the name of the Helm Chart, and matches the `charts/<chart-name>` subdirectory. Ie: `prometheus`
* `oss-version-number` is the Chart version number in the open source subchart; ie., the `version` found in `charts/prometheus/charts/prometheus/Chart.yaml`
* `fedstart-version-number` is the version associated with the version of the outer chart found in `charts/<chart-name>` and should be the `version` found in the `chart/<chart-name>/Chart.yaml`. This number should be represented as a monotonically increasing integer with at most 3 digits of padding. The digits used for this version will be reduced if the `<oss-version-number>` uses more than one digit, such that the `<oss-version-number><fedstart-version-number>` portion is always exactly 4 digits.

## Packaging

Each helm chart can be packaged separately and published to a container registry.

```shell
# Package a single helm-chart product
helm package -d ./build ./charts/<helm-chart-name>

# Publish the packaged helm-chart to a container registry
# NOTE: You must be logged into the helm repository before trying to push
helm push ./build/<packaged-helm-chart> <helm-repository-url>
```

### Example: Using Amazon Elastic Container Registry (ECR)

The following example packages the [vector](./charts/vector) helm-chart, pushes it to ECR, and creates a new product-release in Apollo.

Pre-requisites:

1. An ECR registry exists with a repository named `vector`
   1. We will use `12345.dkr.ecr.us-east-1.amazonaws.com` where `accountID=12345` and `region=us-east-1`
2. `helm`, `aws`, and `apollo-cli` are on the users `$PATH`
3. `apollo-cli` is configured for the correct Apollo hub

```shell
# Package the vector helm-chart
$ helm package -d ./build ./charts/vector
Successfully packaged chart and saved it to: build/vector-0.31.1001.tgz

# Get an AWS access-token and log into ECR using helm
$ aws ecr get-login-password | helm registry login --username AWS --password-stdin 12345.dkr.ecr.us-east-1.amazonaws.com
Login Succeeded

# Push the packaged helm-chart to ECR
$ helm push ./build/vector-0.31.1001.tgz 12345.dkr.ecr.us-east-1.amazonaws.com
Pushed: 12345.dkr.ecr.us-east-1.amazonaws.com/vector:0.31.1001
Digest: sha256:83fde30c20f51e3e1a071bddc21d0f0b4662002678dc5eb3b62c666bd0d568b9
```

Once the packaged helm-chart is pushed to the container registry, we can now create an Apollo product-release which will be used to create a helm-chart entity in an Apollo environment.

```shell
$ apollo-cli publish helm-chart \
    --chart-file ./build/vector-0.31.1001.tgz \
    --helm-repository-url "oci://12345.dkr.ecr.us-east-1.amazonaws.com/vector" \
    --maven-coordinate "com.palantir.vector:vector-aggregator:0.31.1001"
Publishing product release com.palantir.vector:vector-aggregator:0.31.1001 into Apollo ... done
```
