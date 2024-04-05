{{/* Snippet for the nginx file used by gateway */}}
{{- define "myloki.nginxFile" }}
worker_processes  5;  ## Default: 1
error_log  /dev/stderr;
pid        /tmp/nginx.pid;
worker_rlimit_nofile 8192;

events {
  worker_connections  4096;  ## Default: 1024
}

http {
  client_body_temp_path /tmp/client_temp;
  proxy_temp_path       /tmp/proxy_temp_path;
  fastcgi_temp_path     /tmp/fastcgi_temp;
  uwsgi_temp_path       /tmp/uwsgi_temp;
  scgi_temp_path        /tmp/scgi_temp;

  client_max_body_size  4M;

  proxy_read_timeout    600; ## 10 minutes
  proxy_send_timeout    600;
  proxy_connect_timeout 600;

  proxy_http_version    1.1;

  default_type application/octet-stream;
  log_format   {{ .Values.gateway.nginxConfig.logFormat }}

  {{- if .Values.gateway.verboseLogging }}
  access_log   /dev/stderr  main;
  {{- else }}

  map $status $loggable {
    ~^[23]  0;
    default 1;
  }
  access_log   /dev/stderr  main  if=$loggable;
  {{- end }}

  sendfile     on;
  tcp_nopush   on;
  resolver {{ .Values.global.dnsService }}.{{ .Values.global.dnsNamespace }}.svc.{{ .Values.global.clusterDomain }}.;

    {{- $writeHost := include "loki.writeFullname" .}}
    {{- if gt (int .Values.singleBinary.replicas) 0 }}
    {{- $writeHost = include "loki.singleBinaryFullname" .}}
    {{- end }}
    {{- $serverName := printf "%s.%s.svc.%s" $writeHost .Release.Namespace .Values.global.clusterDomain }}

  server {
    listen             8080;
    server_name        {{ $serverName }};
    return             301 https://{{ $serverName }}$request_uri;
  }
  server {
    listen             443 default_server ssl;
    server_name        {{ $serverName }};

    ssl_certificate     /mnt/secrets/certs/tls.crt;
    ssl_certificate_key /mnt/secrets/certs/tls.key;
    # add Strict-Transport-Security to prevent man in the middle attacks
    add_header Strict-Transport-Security "max-age=31536000" always;

    {{- $writeUrl    := printf "https://%s:%s" $serverName (.Values.loki.server.http_listen_port | toString) }}

    # Distributor
    location = /loki/api/v1/push {
      proxy_pass       {{ $writeUrl }}$request_uri;
    }
  }
}
{{- end }}