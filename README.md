# Hello Gdockerfiles/o
Very simple hello world server in go.

## Podman/Docker

### Full
This uses a container that has golang tools installed in it to build the golang binaries for you.  Use only if you do not have golang tools installed locally on your computer.

#### Build
```
podman build -f ./dockerfiles/Dockerfile -t hello-go .
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
podman build -f ./dockerfiles/Dockerfile.slim -t hello-go .
```

#### Run
```
podman run --rm --name hello-go -p 8080:8080 hello-go
```

### OpenShift
```
oc new-project hello-dev
oc new-project hello-cicd
oc policy add-role-to-user edit system:serviceaccount:hello-cicd:pipeline -n hello-dev
oc policy add-role-to-user system:image-puller system:serviceaccount:hello-dev:default -n hello-cicd
oc apply -f https://raw.githubusercontent.com/tektoncd/catalog/main/task/golang-test/0.2/golang-test.yaml
```
