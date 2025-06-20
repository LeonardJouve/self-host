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
    type    = map(object({
        name      = string
        usernames = list(string)
    }))
    default = []
}
