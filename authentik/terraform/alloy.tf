resource "authentik_user" "alloy_user" {
    username = "alloy"
    name     = "Alloy"
    type     = "service_account"
}

resource "authentik_token" "alloy_token" {
    identifier = "alloy_token"
    user       = authentik_user.alloy_user.id
    expires    = timeadd(timestamp(), "${365 * 24}h")
    intent     = "app_password"
}
