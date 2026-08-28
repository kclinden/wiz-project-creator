// Module inputs for project catalog location and Wiz API authentication.
// Sensitive values should come from local tfvars or environment variables and
// should not be committed to source control.
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
