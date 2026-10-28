## Build image

```bash
docker build --platform linux/amd64 -t herdr .
docker tag herdr ghcr.io/leonardjouve/herdr:latest
docker push ghcr.io/leonardjouve/herdr:latest
```

## Headscale policy

In the Headscale Helm values, under `policy.content`:

```yaml
tagOwners:
  tag:herdr: ["leonard@"]
acls:
  - action: accept
    src: ["leonard@"]
    dst: ["tag:herdr:22"]
ssh:
  - action: accept
    src: ["leonard@"]
    dst: ["tag:herdr"]
    users: ["root"]
```

## Create secrets

Tagged, single-use auth key. It is only read on first boot:

```bash
kubectl create namespace herdr
KEY=$(kubectl -n headscale exec deploy/headscale -- headscale preauthkeys create --tags tag:herdr --expiration 1h -o json | jq -r .key)
kubectl -n herdr create secret generic herdr-tailscale --from-literal=authkey="$KEY"
```

```bash
kubectl -n herdr create secret generic herdr-env \
  --from-literal=LITELLM_KEY=sk-... \
  --from-literal=ANTHROPIC_BASE_URL=https://ai.jouve.ch \
  --from-literal=ANTHROPIC_CUSTOM_HEADERS="x-litellm-api-key: Bearer sk-..."
```

## Install

```bash
helm upgrade --install herdr ./chart -n herdr --set image.tag="latest@$(docker image inspect ghcr.io/leonardjouve/herdr:latest --format '{{index .RepoDigests 0}}' | cut -d@ -f2)"
```
PowerShell:
```powershell
$digest = (docker image inspect ghcr.io/leonardjouve/herdr:latest --format "{{index .RepoDigests 0}}").Split('@')[1]
helm upgrade --install herdr ./chart -n herdr --set image.tag="latest@$digest"
```
cmd.exe:
```bat
for /f "tokens=2 delims=@" %d in ('docker image inspect ghcr.io/leonardjouve/herdr:latest --format "{{index .RepoDigests 0}}"') do helm upgrade --install herdr ./chart -n herdr --set image.tag=latest@%d
```

Check that the node registered:

```bash
kubectl -n headscale exec deploy/headscale -- headscale nodes list
```

## Connect

```bash
ssh root@herdr.headscale.local
herdr --remote root@herdr.headscale.local
herdr machine add root@herdr.headscale.local
```
