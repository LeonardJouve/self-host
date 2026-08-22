# Installation

## Create namespace

```
kubectl create namespace forgejo
```

## Create secret with S3 credentials

```
kubectl create secret generic forgejo-s3 -n forgejo --from-literal=access-key= --from-literal=secret-key=
```

## Install helm chart

```
helm install forgejo -n forgejo -f values.yaml oci://code.forgejo.org/forgejo-helm/forgejo
```

## Upgrade

```
helm upgrade forgejo -n forgejo -f values.yaml oci://code.forgejo.org/forgejo-helm/forgejo
```

# Connection

User: `gitea_admin`

Password: `password`
