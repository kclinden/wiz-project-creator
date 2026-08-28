terraform {
  # Pin the provider namespace/source so Terraform resolves the correct Wiz v2
  # plugin implementation for project resources.
  required_providers {
    wiz-v2 = {
      source = "tf.app.wiz.io/wizsec/wiz-v2"
    }
  }
}

provider "wiz-v2" {
  # These credentials are injected via Terraform input variables (typically from
  # terraform.tfvars or TF_VAR_* environment variables). Keeping secrets out of
  # static provider blocks helps avoid accidental credential leakage in VCS.
  env = "fedramp"
  client_id     = var.wiz_auth_client_id
  client_secret = var.wiz_auth_client_secret
}
