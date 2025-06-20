```bash
cp .env.example .env
echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
AUTHENTIK_TOKEN=$(openssl rand -base64 60 | tr -d '\n')
echo "AUTHENTIK_BOOTSTRAP_TOKEN=${BOOTSTRAP_TOKEN}" >> .env
echo "authentik_token = \"${BOOTSTRAP_TOKEN}\"" >> terraform/terraform.tfvars
```
