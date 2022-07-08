.PHONY: build
build: clean
	GOOS=linux GOARCH=amd64 go build -o bin/hello-go-linux-amd64 main.go
	GOOS=darwin GOARCH=amd64 go build -o bin/hello-go-mac-amd64 main.go

.PHONY: run
run:
	go run main.go

.PHONY: clean
clean:
	rm -rf ./bin/*
