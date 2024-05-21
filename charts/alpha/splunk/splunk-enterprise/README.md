# Splunk Operator 

A Palantir Fedstart compliant helm-chart that configures [Splunk Operator](https://github.com/splunk/splunk-operator)

## Configuration

* Refer to [this page from the Splunk documentation](https://splunk.github.io/splunk-ansible/ADVANCED.html) for a list of all environment variables you can set
to configure Splunk Enterprise deployments.
* Refer to [this page](https://splunk.github.io/splunk-operator/CustomResources.html) for details on
available configuration overrides for Splunk CRDs.
* For general upstream configuration overrides, reference the two files linked below
  * [Splunk Operator chart overrides](https://github.com/splunk/splunk-operator/tree/main/helm-chart/splunk-operator)
  * [Splunk Enterprise chart overrides](https://github.com/splunk/splunk-operator/blob/main/helm-chart/splunk-enterprise/values.yaml)
 
### Images

| Image                                                                                                                                                                                                                               | Description                                                | Tags                                                   | Key                                               |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |--------------------------------------------------------|---------------------------------------------------| 
| `docker.io/splunk/splunk-operator`                                 | Splunk Operator image. Handles provisioning and managing Splunk Enterprise instances.                                                                                                                                                                                                                                | https://hub.docker.com/r/splunk/splunk-operator/tags                                                                | `splunk-operator.splunkOperator.image.repository` |
| `docker.io/splunk/splunk`                                          | Splunk Enterprise image. Runs the Splunk application.                                                                                                                                                                                                                                                                                                                                                                                                         | https://hub.docker.com/r/splunk/splunk/tags            | `image`                                           |
| `quay.io/brancz/kube-rbac-proxy`                                   | kube-rbac-proxy image. Acts as an authentication proxy that provides secure access to Kubernetes API endpoints. It verifies incoming requests and ensures they have the appropriate permissions to access the requested resources.                                                                                                                                                                                                                            | https://quay.io/repository/brancz/kube-rbac-proxy?tab=tags | `splunk-operator.kubeRbacProxy.image.repository` |


### Environment Variables

| Environment Variable | Description                                                                                                                                                                                                                                                     | Default |
|---------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| ---------- |
| `SPLUNK_ROOT_ENDPOINT` | Sets the path at which the Splunk Web server will serve requests. This value must match the route set under the "prefix" key within the com.palantir.rubix.service.spp/v3 service annotation used to configure the Envoy proxy route to the splunk-web-service. | `/splunkweb`           |
