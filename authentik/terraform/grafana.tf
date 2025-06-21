resource "authentik_group" "grafana" {
    name = "Grafana"
}

resource "authentik_group" "grafana_admins" {
    name   = "Grafana Admins"
    parent = authentik_group.grafana.id
}

resource "authentik_group" "grafana_editors" {
    name = "Grafana Editors"
    parent = authentik_group.grafana.id
}

resource "random_id" "grafana_client_id" {
    byte_length = 40
}

resource "authentik_provider_oauth2" "grafana_oauth2_provider" {
    name                  = "grafana"
    client_id             = random_id.grafana_client_id.hex
    authorization_flow    = data.authentik_flow.default-authorization-flow.id
    invalidation_flow     = data.authentik_flow.default-invalidation-flow.id
    allowed_redirect_uris = [{
        matching_mode = "strict",
        url           = "${var.grafana_url}/login/generic_oauth",
    }]
    property_mappings     = [
        data.authentik_property_mapping_provider_scope.email_mapping.id,
        data.authentik_property_mapping_provider_scope.profile_mapping.id,
        data.authentik_property_mapping_provider_scope.openid_mapping.id,
    ]
}

resource "authentik_policy_binding" "grafana_policy_binding" {
    target = authentik_application.grafana_application.uuid
    group  = authentik_group.grafana.id
    order  = 0
}

resource "authentik_application" "grafana_application" {
    name              = "Grafana"
    slug              = "grafana"
    group             = "observability"
    meta_icon         = "https://grafana.com/media/docs/grafana-cloud/infrastructure/grafanalogo.svg"
    protocol_provider = authentik_provider_oauth2.grafana_oauth2_provider.id
}

resource "authentik_user" "grafana_user" {
    username = "grafana"
    name     = "Grafana"
    type     = "service_account"
}

resource "authentik_token" "grafana_token" {
    identifier = "grafana_token"
    user       = authentik_user.grafana_user.id
    expires    = timeadd(timestamp(), "${365 * 24}h")
    intent     = "app_password"
}
