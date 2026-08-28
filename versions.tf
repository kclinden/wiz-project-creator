terraform {
  # Require a modern Terraform baseline so object expressions, for_each maps,
  # and function behavior used by this module stay predictable across machines.
  required_version = ">= 1.5.0"
}
