terraform {
    required_providers {
        authentik = {
            source = "goauthentik/authentik"
            version = "2025.6.0"
        }
        random = {
            source = "hashicorp/random"
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

data "authentik_property_mapping_provider_scope" "entitlements_mapping" {
    scope_name = "entitlements"
}

data "authentik_property_mapping_provider_scope" "email_mapping" {
    scope_name = "email"
}

data "authentik_property_mapping_provider_scope" "openid_mapping" {
    scope_name = "openid"
}

data "authentik_property_mapping_provider_scope" "profile_mapping" {
    scope_name = "profile"
}

data "authentik_property_mapping_provider_scope" "ak_proxy_mapping" {
    scope_name = "ak_proxy"
}
