# Hello Go
Very simple hello world server in go.

## Podman/Docker

### Full
This uses a container that has golang tools installed in it to build the golang binaries for you.  Use only if you do not have golang tools installed locally on your computer.

#### Build
```
podman build -t hello-go .
```

#### Run
```
podman run --rm --name hello-go -p 8080:8080 hello-go
```

### Slim
This produces smaller containers, but you will need to have golang tools installed on your computer to pre-build the binaries.

#### Build
```
make
podman build -f ./Dockerfile.slim -t hello-go .
```

#### Run
```
podman run --rm --name hello-go -p 8080:8080 hello-go
```
