# Splunk Operator

A Palantir Fedstart compliant helm-chart that configures [Splunk Operator](https://github.com/splunk/splunk-operator).

## Configuration

Note: This chart has only been tested through deploying a single standalone Splunk instance.

### Resources

* Refer to [this page from the Splunk documentation](https://splunk.github.io/splunk-ansible/ADVANCED.html) for a list of all environment variables you can set
to configure Splunk Enterprise deployments.
* Refer to [this page](https://splunk.github.io/splunk-operator/CustomResources.html) for details on
available configuration overrides for Splunk CRDs.
* For general upstream configuration overrides, reference the two files linked below
  * [Splunk Operator chart overrides](https://github.com/splunk/splunk-operator/tree/main/helm-chart/splunk-operator)
  * [Splunk Enterprise chart overrides](https://github.com/splunk/splunk-operator/blob/main/helm-chart/splunk-enterprise/values.yaml)
* For details on the different components of a Splunk Enterprise instance and the supported deployment architectures,
refer to these [Splunk docs](https://docs.splunk.com/Documentation/SVA/current/Architectures/About).

### Required Configuration Details

* You will need to set the `Default host name` field under the `Server settings > General Settings` page to the frontdoor domain on which
you are mounting your Splunk instance. Example: fedstart-splunk.palantirfedstart.com.
* You will need to mount your Splunk instance at the root path of what ever front door domain you are using. Otherwise, app integrations
may not work.

### Images Used by This Chart

| Image                                                                                                                                                                                                                               | Description                                                | Tags                                                                               | Override Key                                      |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |------------------------------------------------------------------------------------|---------------------------------------------------|
| `docker.io/splunk/splunk-operator`                                 | Splunk Operator image. Handles provisioning and managing Splunk Enterprise instances.                                                                                                                                                                                                                                | [splunk-operator tags](https://hub.docker.com/r/splunk/splunk-operator/tags)       | `splunk-operator.splunkOperator.image.repository` |
| `docker.io/splunk/splunk`                                          | Splunk Enterprise image. Runs the Splunk application.                                                                                                                                                                                                                                                                                                                                                                                                         | [splunk enterprise tags](https://hub.docker.com/r/splunk/splunk/tags)              | `image`                                           |
| `quay.io/brancz/kube-rbac-proxy`                                   | kube-rbac-proxy image. Acts as an authentication proxy that provides secure access to Kubernetes API endpoints. It verifies incoming requests and ensures they have the appropriate permissions to access the requested resources.                                                                                                                                                                                                                            | [kube-rbac-proxy tags](https://quay.io/repository/brancz/kube-rbac-proxy?tab=tags) | `splunk-operator.kubeRbacProxy.image.repository`  |

## Integrations

### SSO

Note: When setting up SSO, be sure to set the load balancer in the Splunk authentication configuration to be
  the frontdoor domain where you are accessing Splunk from. The load balancer port should be set to 443.

* SSO has been tested and validated using Keycloak as an OIDC client.

### Alerting

* Alerting via an integration with PagerDuty has been tested and validated for this chart
  * Note: You will not be able to download apps directly from Splunkbase via the app browser in Splunk Web
  and will instead need to download apps from splunkbase.splunk.com and upload them to your instance of
  Splunk via the app manager page. All updates to apps on your Splunk instance will also need to follow
  this process.
