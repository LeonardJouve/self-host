variable "authentik_url" {
    type = string
}

variable "authentik_token" {
    type      = string
    sensitive = true
}

variable "loki_url" {
    type = string
}

variable "grafana_url" {
    type = string
}

variable "organizations" {
    type    = set(string)
    default = []
}
