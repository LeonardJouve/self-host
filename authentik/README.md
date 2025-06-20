```bash
cp .env.example .env
echo "AUTHENTIK_SECRET_KEY=$(openssl rand -base64 60 | tr -d '\n')" >> .env
echo "AUTHENTIK_BOOTSTRAP_TOKEN=$(openssl rand -base64 60 | tr -d '\n')" >> .env
```
