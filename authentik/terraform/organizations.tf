resource "random_uuid" "organization_ids" {
    for_each = var.organizations
}

resource "authentik_group" "groups" {
    for_each   = var.organizations
    name       = each.key
    attributes = jsonencode({
        "organization-id": random_uuid.organization_ids[each.key].result
    })
}
