resource "authentik_user" "users" {
    for_each = var.users
    username = each.key
    name     = title(each.key)
    password = "changeme"
}
