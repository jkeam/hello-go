.PHONY: build
build: clean
	GOOS=linux GOARCH=amd64 go build -o hello-go main.go

.PHONY: buildmac
buildmac: clean
	GOOS=darwin GOARCH=arm64 go build -o hello-macos-arm64 main.go

.PHONY: run
run:
	go run main.go

.PHONY: clean
clean:
	rm -rf ./hello-go ./hello-macos-arm64
