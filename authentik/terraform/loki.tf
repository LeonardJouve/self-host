data "authentik_group" "loki" {
    name = "loki"
}

resource "authentik_policy_binding" "loki_policy_binding" {
    target = authentik_application.loki_application.uuid
    group  = data.authentik_group.loki.id
    order  = 0
}

resource "authentik_property_mapping_provider_scope" "loki_property_mapping" {
    name       = "loki-org-id"
    scope_name = "loki-org-id"
    expression = <<EOF
org_ids = []

for group in request.user.ak_groups.all():
    org_id = group.attributes.get("organization-id")
    if org_id:
        org_ids.append(org_id)

merged_org_ids = "|".join(org_ids) if org_ids else "default-organization"

return {
    "ak_proxy": {
        "user_attributes": {
            "additionalHeaders": {
                "X-Scope-OrgID": merged_org_ids
            }
        }
    }
}
EOF
}

resource "authentik_provider_proxy" "loki_provider_proxy" {
    name               = "loki"
    external_host      = var.loki_url
    mode               = "forward_single"
    property_mappings  = ["loki-org-id"]
    authorization_flow = data.authentik_flow.default-authorization-flow.id
    invalidation_flow  = data.authentik_flow.default-invalidation-flow.id
}

resource "authentik_application" "loki_application" {
    name              = "Loki"
    slug              = "loki"
    group             = "observability"
    protocol_provider = authentik_provider_proxy.loki_provider_proxy.id
}

resource "authentik_outpost" "loki_outpost" {
    name = "loki_outpost"
    protocol_providers = [
        authentik_provider_proxy.loki_provider_proxy.id
    ]
}
