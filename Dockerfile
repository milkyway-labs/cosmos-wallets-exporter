FROM golang:1.22-alpine AS builder

ENV PACKAGES="curl make git libc-dev bash gcc linux-headers eudev-dev python3 ca-certificates build-base"
RUN set -eux; apk add --no-cache $PACKAGES;

WORKDIR /code
COPY . /code/

RUN make build


FROM alpine:latest

# Set up dependencies
RUN apk update && apk add --no-cache ca-certificates build-base

# Copy the binary
COPY --from=builder /code/cosmos-wallets-exporter /usr/bin/cosmos-wallets-exporter

ENTRYPOINT ["cosmos-wallets-exporter"]