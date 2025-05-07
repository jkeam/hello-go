FROM registry.access.redhat.com/ubi9/go-toolset:1.23.6-1746547777 AS builder

USER root
WORKDIR /go/src/app
COPY main.go go.mod Makefile ./

RUN go get .
RUN make

FROM registry.access.redhat.com/ubi9/ubi-micro:9.5-1746002938
COPY --from=builder /go/src/app/hello-go ./
USER nobody
EXPOSE 8080
CMD ["./hello-go"]
