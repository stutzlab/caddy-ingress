# caddy-ingress

Docker label configurable Caddy proxy with Prometheus Exporter support

Plugins enabled in this Caddy binary:

* https://github.com/JokerQyou/caddy-prometheus for Prometheus Exporter
* github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 for Docker label configuration

## Usage

* Create docker-compose.yml

```yml
version: '3.5'
services:
  caddy:
    image: stutzlab/caddy-ingress
    labels:
      - caddy.order=prometheus first
    ports:
      - 8080:80
      - 8443:443
      - 9180:9180
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - caddy:/root

  helloworld:
    image: whalesalad/docker-debug
    labels:
      - caddy=localhost
      - caddy.reverse_proxy={{upstreams 8080}}
      - caddy.encode=gzip
      - caddy.prometheus=0.0.0.0:9180

volumes:
  caddy:
```

* run ```docker-compose up -d```

* ```curl https://localhost:8080/```

* See hello world site!
