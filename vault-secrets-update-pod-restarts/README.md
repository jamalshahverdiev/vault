#### Build new Vault docker agent

```bash
$ docker build -t docker.registry.domain/company-images/company/vaultagent:v1 .
$ docker push docker.registry.domain/company-images/company/vaultagent:v1
```


#### Now we need to add following [annotations](https://developer.hashicorp.com/vault/docs/platform/k8s/injector/annotations) in our application deployment:

```bash
vault.hashicorp.com/agent-inject-secret-config: company/account-service
vault.hashicorp.com/agent-image: docker.registry.domain/company-images/company/vaultagent:v1
vault.hashicorp.com/agent-inject-command-config: "sh /opt/restart_deployment.sh"
```

#### Edit deployment to specify `shareProcessNamespace: true` like as the following

```bash
    spec:
      shareProcessNamespace: true
      containers:
      - args:
        - -c
        - . /vault/secrets/config && bundle exec gruf
        command:
        - /bin/sh
```
