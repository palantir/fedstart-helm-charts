# Memcached

A Palantir Fedstart compliant helm-chart that configures [memcached](https://github.com/memcached/memcached).

## Configuration

Refer to the Memcached [README](https://github.com/bitnami/charts/blob/main/bitnami/memcached/README.md) for all available upstream configuration options.

## TLS Encryption Support

To enable TLS encryption support for memcached, it requires a special build flag to compile `openssl` dependencies into the binaries ([source](https://github.com/memcached/memcached/wiki/TLS)).

**The bitnami image referenced in the upstream helm chart does *not* have the necessary `openssl` depdencnies to enable TLS encryption support. This chart explicitly overrides the image registry, repository, and tag to utilize the official DockerHub image with TLS encryption support.**

```yaml
image:
    registry: docker.io
    repository: library/memcached
    tag: 1.6.29-alpine
```

This also requires explicit override of container startup arguments to start memcached in TLS mode.

```yaml
args:
  - "--extended=modern"
  - "-Z" # Enable TLS
  - "-ossl_chain_cert=/mnt/secrets/certs/tls.crt,ssl_key=/mnt/secrets/certs/tls.key,ssl_ca_cert=/mnt/secrets/certs/ca.crt,ssl_verify_mode=0"
  - "--memory-file=/cache-state/memory_file"
```
