FROM registry.access.redhat.com/ubi9/go-toolset@sha256:2837f91fba7f07c112a6052a99912fc364fd7373fb94d60c22ca4d7a79f1e79d

WORKDIR /go/src/app
COPY main.go go.mod Makefile .

RUN go get .
RUN make

USER nobody
EXPOSE 8080
CMD ["./bin/hello-go-linux-amd64"]
