
# https://hub.docker.com/_/golang/tags
FROM docker.io/golang:1.24-alpine AS builder

WORKDIR /traefik-auth-cloudflare
COPY . .

RUN set -x \
    && go mod tidy \
    && cat go.sum

RUN set -x \
    && go build \
    && ./traefik-auth-cloudflare || true


# https://hub.docker.com/_/alpine/tags
FROM docker.io/alpine:3

# Switch to non-root user
RUN adduser -D app
USER app
WORKDIR /home/app

COPY --from=builder --chown=app:app /traefik-auth-cloudflare/traefik-auth-cloudflare ./

ENTRYPOINT ["./traefik-auth-cloudflare"]
