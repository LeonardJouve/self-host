# CRW

```bash
helm upgrade --install crw ./chart --namespace crw --create-namespace --set "auth.apiKeys=crw_live_$(openssl rand -hex 24)"
kubectl -n crw get secret crw-auth -o go-template="{{index .data \"apiKeys\" | base64decode}}"
```

