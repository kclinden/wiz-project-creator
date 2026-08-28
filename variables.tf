// Inputs for project config location and Wiz authentication.
variable "projects_yaml_path" {
  description = "Path to the YAML file that defines Wiz projects."
  type        = string
  default     = "config/projects.yaml"
}

variable "wiz_url" {
  description = "Wiz API URL (for example: https://api.us20.app.wiz.io)."
  type        = string
}

variable "wiz_auth_client_id" {
  description = "Wiz OAuth client ID."
  type        = string
  sensitive   = true
}

variable "wiz_auth_client_secret" {
  description = "Wiz OAuth client secret."
  type        = string
  sensitive   = true
}

variable "wiz_auth_audience" {
  description = "Wiz OAuth audience."
  type        = string
  default     = "wiz-api"
}
