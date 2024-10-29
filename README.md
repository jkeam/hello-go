# Hello Go
Very simple hello world server in go.

## Podman/Docker

### Full

This uses a container that has golang tools installed in it to build the golang
binaries for you.  Use only if you do not have golang tools installed locally
on your computer.

#### Building Full

```shell
podman build -f ./dockerfiles/Dockerfile -t hello-go .
```

#### Running Full

```shell
podman run --rm --name hello-go -p 8080:8080 hello-go
```

### Slim

This produces smaller containers, but you will need to have golang tools
installed on your computer to pre-build the binaries.

#### Building Slim

```shell
make
podman build -f ./dockerfiles/Dockerfile.slim -t hello-go .
```

#### Running Slim

```shell
podman run --rm --name hello-go -p 8080:8080 hello-go
```

### OpenShift

These are the instructions to be able to run the pipeline created in this
[video](https://people.redhat.com/~jkeam/#/pipelines) named `Pipeline Demo`.

```shell
# Create projects
oc new-project hello-dev
oc new-project hello-cicd

# Update service account permissions
oc policy add-role-to-user edit system:serviceaccount:hello-cicd:pipeline -n hello-dev
oc policy add-role-to-user system:image-puller system:serviceaccount:hello-dev:default -n hello-cicd

# Create tasks
oc apply -f ./pipeline/golang-test-task.yaml -n hello-cicd
oc apply -f ./pipeline/golang-build-clustertask.yaml -n hello-cicd

# Create pipeline
oc apply -f ./pipeline/pipeline.yaml

# Run pipeline
oc create -f ./pipeline/pipeline-run.yaml
```

#### Quay

While completely optional, to push to quay instead of deploying, you can also edit the pipeline
(pipeline/pipeline.yaml) to drop the `deploy-dev` command and update the `buildah`
task to perform a push to some registry.  This is what is done in
`pipeline/pipeline-to-quay.yaml`.  The quay repository is currently hardcoded,
but we can easily change this to a parameter.

Before doing that, you will need to add quay credentials via a secret:

```shell
oc create secret -n hello-cicd docker-registry container-registry-secret \
  --docker-server='quay.io' \
  --docker-username='your-quay-robot-account-name' \
  --docker-password='your-quay-robot-account-password'
```

And then attach that secret to the `pipeline` service account, unless you are
using some other custom service account.

```shell
oc patch serviceaccount pipeline -p '{"secrets": [{"name": "container-registry-secret"}]}'
```
