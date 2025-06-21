resource "authentik_user" "alloy_user" {
    username   = "alloy"
    name       = "Alloy"
    type       = "service_account"
    groups     = [authentik_group.loki.id]
    attributes = jsonencode({
        "goauthentik.io/user/token-expires"          = true
        "goauthentik.io/user/token-maximum-lifetime" = "days=365"
    })
}

resource "authentik_token" "alloy_token" {
    identifier   = "alloy_token"
    user         = authentik_user.alloy_user.id
    expires      = timeadd(timestamp(), "${365 * 24}h")
    intent       = "app_password"
    retrieve_key = true
}

output "alloy_token" {
    value     = authentik_token.alloy_token.key
    sensitive = true
}
