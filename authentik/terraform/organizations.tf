data "authentik_users" "all" {
}

resource "random_uuid" "organization_ids" {
    for_each = var.organizations
}

resource "authentik_group" "groups" {
    for_each   = var.organizations
    name       = each.value.name
    users      = flatten([
        for username in each.value.usernames : [
            for user in data.authentik_users.all.users : user.id if u.username == username
        ]
    ])
    attributes = {
        "organization-id": random_uuid.organization_ids[each.key].result
    }
}
