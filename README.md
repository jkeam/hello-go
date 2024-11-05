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
oc apply -f ./pipeline/tasks/golang-test-task.yaml -n hello-cicd
oc apply -f ./pipeline/tasks/golang-build-task.yaml -n hello-cicd

# Create pipeline
oc apply -f ./pipeline/pipeline.yaml -n hello-cicd

# Run pipeline
oc create -f ./pipeline/pipeline-run.yaml -n hello-cicd
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

#### GitOps

If you have OpenShift GitOps installed, we can use [hello-go-config](https://github.com/jkeam/hello-go-config) as a repo that ArgoCD uses to do deployments.

First fork the [hello-go-config](https://github.com/jkeam/hello-go-config) and generate a GitHub token that has access to push commits to it.

Next follow the README instructions in [hello-go-config](https://github.com/jkeam/hello-go-config) in order to set up the ArgoCD application.

Then come back here and do the following steps to finish setting up the pipeline.

```shell
# Replace with GitHub token info and create secret
oc apply -f ./pipeline/gitops/secret.yaml -n hello-cicd

# Add secret to to pipeline service account
oc patch serviceaccount pipeline -p '{"secrets": [{"name": "github-credentials"}]}' -n hello-cicd

# Create task
oc apply -f ./pipeline/gitops/git-update-deployment-task.yaml -n hello-cicd

# Create special gitops pipeline
oc apply -f ./pipeline/gitops/pipeline-gitops.yaml -n hello-cicd

# Run pipeline
oc create -f ./pipeline/gitops/pipeline-gitops-run.yaml -n hello-cicd
```

#### Webhook

To add a webhook, update the `APP_SOURCE_GIT` and `CONFIG_GIT_REPO` values in `./trigger/trigger-template.yaml` and then update apply it.

```shell
oc apply -k ./pipeline/trigger -n hello-cicd
```

And in the git repo, add the following url as a webhook on push events.

```shell
echo "http://$(oc get routes/el-hello-go -n hello-cicd -o jsonpath='{.spec.host}')"
```
