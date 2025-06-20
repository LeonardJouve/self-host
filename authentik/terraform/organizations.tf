data "authentik_users" "all" {
}

resource "random_uuid" "organization_ids" {
    for_each = var.organizations
}

resource "authentik_group" "groups" {
    for_each   = var.organizations
    name       = each.key
    users      = flatten([
        for username in each.value : [
            for user in data.authentik_users.all.users : user.id if user.username == username
        ]
    ])
    attributes = jsonencode({
        "organization-id": random_uuid.organization_ids[each.key].result
    })
}
