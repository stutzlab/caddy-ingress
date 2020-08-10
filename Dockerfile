FROM golang:1.14.3-alpine3.11 AS BUILD
RUN apk add -U --no-cache ca-certificates git

RUN go get -u github.com/caddyserver/xcaddy/cmd/xcaddy

WORKDIR /tmp
#use this fork of caddy-prometheus because it has support for caddy v2
RUN git clone http://github.com/JokerQyou/caddy-prometheus

RUN CGO_ENABLED=0 \
    xcaddy build \
    --output /app/caddy \
    --with github.com/lucaslorentz/caddy-docker-proxy/plugin/v2 \
    --with github.com/miekg/caddy-prometheus=/tmp/caddy-prometheus

FROM scratch

EXPOSE 80 443 2019
ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

WORKDIR /
COPY --from=BUILD /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=BUILD /app/caddy /bin/caddy

ENTRYPOINT ["/bin/caddy"]

CMD ["docker-proxy"]

