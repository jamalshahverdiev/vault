### Create NS and secret in NS

```bash
$ kubectl create ns bankvault
```

#### Install Vault operator

```bash
$ helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
$ helm upgrade --install vault-operator banzaicloud-stable/vault-operator -n bankvault
```

#### Apply `ServiceAccount`,`RoleBindings`, `gcp-sa.yaml` secret, `vault-ingress.yaml` ingress and `Vault` CustomResourceDefinition to the `bankvault` namespace

```bash
$ kubectl apply -f Manifests/sa-role-rolebinding.yaml -n bankvault
$ kubectl apply -f Manifests/cr-gcs-ha.yaml -n bankvault
$ kubectl apply -f Manifests/gcp-sa.yaml -n bankvault
$ kubectl apply -f Manifests/vault-ingress.yaml -n bankvault
```

#### To use vault commands export the following variables

```bash
$ export VAULT_ADDR=https://bvault.infra.companyservices.net/
$ kubectl get secret vault-tls -o jsonpath="{.data.ca\.crt}" -n bankvault | base64 --decode > $PWD/vault-ca.crt
$ export VAULT_CACERT=$PWD/vault-ca.crt # Or export VAULT_SKIP_VERIFY=true
$ export VAULT_TOKEN=$(kubectl get secrets vault-unseal-keys -o jsonpath={.data.vault-root} -n bankvault | base64 --decode)
$ export VAULT_TOKEN=""
$ vault login -method=github token="${VAULT_TOKEN}"
```

#### Deploy WebHook

```bash
$ kubectl create namespace vault-infra
$ kubectl label namespace vault-infra name=vault-infra
$ helm repo add banzaicloud-stable https://kubernetes-charts.banzaicloud.com
$ helm upgrade --namespace vault-infra --install vault-secrets-webhook banzaicloud-stable/vault-secrets-webhook
$ kubectl get pods --namespace vault-infra
NAME                                     READY   STATUS    RESTARTS   AGE
vault-secrets-webhook-54fdff4dfc-pvxt9   1/1     Running   0          6s
vault-secrets-webhook-54fdff4dfc-rclpc   1/1     Running   0          6s
```

#### Get TLS certificate and apply it to microservice folder

```bash
$ kubectl get secret vault-tls -n bankvault -o yaml > Manifests/vault-tls.yaml
```

#### Create new service account

```bash
$ kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: company
  namespace: company-mss
EOF
```

