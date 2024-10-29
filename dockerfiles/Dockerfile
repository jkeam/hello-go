FROM registry.access.redhat.com/ubi9/go-toolset:1.21.13-2.1729776560 AS builder

USER root
WORKDIR /go/src/app
COPY main.go go.mod Makefile ./

RUN go get .
RUN make

FROM registry.access.redhat.com/ubi9/ubi-micro@sha256:2044e2ca8e258d00332f40532db9f55fb3d0bfd77ecc84c4aa4c1b7af3626ffb
COPY --from=builder /go/src/app/hello-go ./
USER nobody
EXPOSE 8080
CMD ["./hello-go"]
