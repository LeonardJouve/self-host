terraform {
    required_providers {
        authentik = {
            source = "goauthentik/authentik"
            version = "2025.6.0"
        }
    }
}

provider "authentik" {
    url   = var.authentik_url
    token = var.authentik_token
}

data "authentik_flow" "default-authorization-flow" {
    slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-invalidation-flow" {
    slug = "default-provider-invalidation-flow"
}
