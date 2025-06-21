resource "authentik_user" "users" {
    for_each = var.users
    username = each.key
    email    = each.value.email
    name     = title(each.key)
    password = "changeme"
}

resource "authentik_user" "grafana_user" {
    username   = "grafana"
    name       = "Grafana"
    type       = "service_account"
    groups     = [authentik_group.loki.id]
    attributes = jsonencode({
        "goauthentik.io/user/token-expires"          = true
        "goauthentik.io/user/token-maximum-lifetime" = "days=365"
    })
}

resource "authentik_token" "grafana_token" {
    identifier   = "grafana_token"
    user         = authentik_user.grafana_user.id
    expires      = timeadd(timestamp(), "${365 * 24}h")
    intent       = "app_password"
    retrieve_key = true
}

output "grafana_token" {
    value     = authentik_token.grafana_token.key
    sensitive = true
}

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
