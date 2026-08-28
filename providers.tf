terraform {
  # Provider source for Wiz v2 resources.
  required_providers {
    wiz-v2 = {
      source = "tf.app.wiz.io/wizsec/wiz-v2"
    }
  }
}

provider "wiz-v2" {
  # Credentials are provided via terraform.tfvars or TF_VAR_* env vars.
  env = "fedramp"
  client_id     = var.wiz_auth_client_id
  client_secret = var.wiz_auth_client_secret
}
