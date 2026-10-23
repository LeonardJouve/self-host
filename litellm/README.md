# Installation

## Create namespace

```
kubectl create namespace litellm
```

## Create secrets

```
kubectl create secret generic litellm-postgres -n litellm --from-literal=username=litellm --from-literal=password=$(openssl rand -hex 24)
kubectl create secret generic litellm-master-key -n litellm --from-literal=master-key=sk-$(openssl rand -hex 24)
kubectl create secret generic litellm-salt-key -n litellm --from-literal=LITELLM_SALT_KEY=sk-$(openssl rand -hex 24)
```

`LITELLM_SALT_KEY` encrypts the provider keys stored in the DB, never change it once set.

## Deploy Postgres

```
kubectl apply -f postgres.yaml
```

## Install

```
helm install litellm -n litellm -f values.yaml oci://ghcr.io/berriai/litellm-helm
```

## Dev

```
kubectl -n litellm port-forward svc/litellm 4000:4000
```

## Disable master key login

First login: user `admin`, password = the master key

```
kubectl -n litellm get secret litellm-master-key -o go-template="{{index .data \"master-key\" | base64decode}}"
```

Create a user with the Proxy Admin role in Internal Users and check it can sign in, then turn off the master key login:

```
helm upgrade litellm -n litellm -f values.yaml oci://ghcr.io/berriai/litellm-helm --set proxy_config.general_settings.disable_env_credential_login=true
```

## ChatGPT subscription

Log in once, the token is stored on the `litellm-chatgpt-auth` volume and refreshed by the proxy:

```
kubectl -n litellm exec -it deploy/litellm -- python -c "from litellm.llms.chatgpt.authenticator import Authenticator; Authenticator().get_access_token()"
```

Then add a model in the UI with Model Name `chatgpt/*`, LiteLLM Model Name `chatgpt/*`, no API key.

## Upgrade

```
helm upgrade litellm -n litellm -f values.yaml oci://ghcr.io/berriai/litellm-helm --set proxy_config.general_settings.disable_env_credential_login=true
```

# Connection

UI: https://ai.jouve.ch/ui

## Codex

```bash
export LITELLM_KEY="sk-..."
```

~/.codex/config.toml
```yaml
model = "chatgpt/gpt-6.1-sol"
model_provider = "litellm"

[features]
api_key_model_discovery = true
suppress_unstable_features_warning = true


[model_providers.litellm]
name = "LiteLLM"
base_url = "https://ai.jouve.ch/v1"
env_key = "LITELLM_KEY"
wire_api = "responses"
model_catalog_url = "https://ai.jouve.ch/v1/models"
```

You might have to set the following config in the NPM proxy config
```
proxy_buffer_size 32k;
proxy_buffers 8 32k;
proxy_busy_buffers_size 64k;
```

## Claude Code

```bash
export ANTHROPIC_BASE_URL="https://ai.jouve.ch"
export ANTHROPIC_CUSTOM_HEADERS="x-litellm-api-key: Bearer sk-..."
```

## Pi

```bash
export LITELLM_KEY="sk-..."
```

~/.pi/agent/models.json
```json
{
  "$schema": "https://pi.dev/schemas/models.schema.json",
  "providers": {
    "litellm": {
      "baseUrl": "https://ai.jouve.ch/v1",
      "api": "openai-completions",
      "apiKey": "$LITELLM_KEY",
      "models": [
        { "id": "qwen/qwen3.8-max", "reasoning": true, "input": ["text", "image"], "contextWindow": 1000000, "maxTokens": 131072 },
        { "id": "qwen/qwen3.8-flash", "reasoning": true, "input": ["text", "image"], "contextWindow": 1000000, "maxTokens": 131072 },
        { "id": "qwen/glm-5.3", "reasoning": true, "input": ["text"], "contextWindow": 1000000, "maxTokens": 131072 },
        { "id": "qwen/deepseek-v4-pro", "reasoning": true, "input": ["text"], "contextWindow": 1000000, "maxTokens": 384000 },
        { "id": "qwen/deepseek-v4-flash", "reasoning": true, "input": ["text"], "contextWindow": 1000000, "maxTokens": 384000 },
        { "id": "qwen/deepseek-v4.1-flash", "reasoning": true, "input": ["text", "image"], "contextWindow": 1000000, "maxTokens": 384000 },
        { "id": "chatgpt/gpt-6.1-sol", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 922000, "maxTokens": 128000 },
        { "id": "chatgpt/gpt-6-sol", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 922000, "maxTokens": 128000 },
        { "id": "chatgpt/gpt-6-luna", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 922000, "maxTokens": 128000 },
        { "id": "chatgpt/gpt-6-astra", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 922000, "maxTokens": 128000 },
        { "id": "chatgpt/gpt-5.6-sol", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 1050000, "maxTokens": 128000 },
        { "id": "chatgpt/gpt-5.6-luna", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 1050000, "maxTokens": 128000 },
        { "id": "chatgpt/gpt-5.6-terra", "api": "openai-responses", "reasoning": true, "input": ["text", "image"], "contextWindow": 1050000, "maxTokens": 128000 }
      ]
    }
  }
}
```
