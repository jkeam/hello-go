FROM registry.access.redhat.com/ubi9/go-toolset@sha256:f925b0f9b6fbb8e445ba00cb671a2c7379c24381a9b75fa8a3abef37a2a6a7a0 AS builder

WORKDIR /go/src/app
COPY main.go go.mod Makefile ./

RUN go get .
RUN make

FROM registry.access.redhat.com/ubi9/ubi-micro@sha256:37b939d8b86b5cad34ce6212480c88b4d731272116d57c46b4acce0516e7d8e6
COPY --from=builder /go/src/app/hello-go ./
USER nobody
EXPOSE 8080
CMD ["./hello-go"]
