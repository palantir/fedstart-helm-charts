FROM bitnami/kubectl:1.27.14-debian-12-r1 as kubectl

FROM --platform=linux/amd64 debian:12

USER 500

WORKDIR /

COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/