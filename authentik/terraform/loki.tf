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

resource "authentik_group" "loki" {
    name = "loki"
}

resource "authentik_policy_binding" "loki_policy_binding" {
    target = authentik_application.loki_application.uuid
    group  = authentik_group.loki.id
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
    property_mappings  = [
        data.authentik_property_mapping_provider_scope.entitlements_mapping,
        data.authentik_property_mapping_provider_scope.email_mapping,
        data.authentik_property_mapping_provider_scope.openid_mapping,
        data.authentik_property_mapping_provider_scope.profile_mapping,
        data.authentik_property_mapping_provider_scope.ak_proxy_mapping,
        authentik_property_mapping_provider_scope.loki_property_mapping.id,
    ]
    authorization_flow = data.authentik_flow.default-authorization-flow.id
    invalidation_flow  = data.authentik_flow.default-invalidation-flow.id
}

resource "authentik_application" "loki_application" {
    name              = "Loki"
    slug              = "loki"
    group             = "observability"
    meta_icon         = "https://grafana.com/static/img/logos/logo-loki.svg"
    protocol_provider = authentik_provider_proxy.loki_provider_proxy.id
}

resource "authentik_outpost" "loki_outpost" {
    name = "loki_outpost"
    protocol_providers = [
        authentik_provider_proxy.loki_provider_proxy.id
    ]
}
