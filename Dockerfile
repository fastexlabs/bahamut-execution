# Support setting various labels on the final image
ARG COMMIT="geth"
ARG VERSION="1.3.4-stable-a1448409"
ARG BUILDNUM="1"

# Build Geth in a stock Go builder container
FROM golang:1.21-alpine as builder

RUN apk add --no-cache gcc musl-dev linux-headers git

# Get dependencies - will also be cached if we won't change go.mod/go.sum
COPY go.mod /go-ethereum/
COPY go.sum /go-ethereum/
RUN cd /go-ethereum && go mod download

ADD . /go-ethereum
RUN cd /go-ethereum && go run build/ci.go install -static ./cmd/geth

# Pull Geth into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["geth"]

# Add some metadata labels to help programatic image consumption
ARG COMMIT="geth"
ARG VERSION="1.3.4-stable-a1448409"
ARG BUILDNUM="1"

LABEL commit="$COMMIT" version="$VERSION" buildnum="$BUILDNUM"
