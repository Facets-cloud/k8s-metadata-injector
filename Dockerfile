FROM golang:alpine as builder
WORKDIR ${GOPATH}/k8s-metadata-injector
COPY . ./
RUN go mod vendor
RUN CGO_ENABLED=0 GOOS=linux go build -o /usr/bin/k8s-metadata-injector

FROM alpine
RUN apk add --no-cache bash openssl curl
COPY --from=builder /usr/bin/k8s-metadata-injector /usr/bin/
COPY hack/gencerts.sh /usr/bin/
ENTRYPOINT ["/usr/bin/k8s-metadata-injector"]
