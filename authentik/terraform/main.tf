provider "authentik" {
    url   = var.authentik_url
    token = var.authentik_token
}

data "authentik_flow" "default-authorization-flow" {
    slug = "default-provider-authorization-implicit-consent"
}
