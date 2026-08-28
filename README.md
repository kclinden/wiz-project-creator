# wiz-project-creator

Terraform configuration to create and manage Wiz Projects from a YAML file.

## Prerequisites

- Terraform `>= 1.5.0`
- Wiz service account/client credentials

## Project configuration

Define projects in `config/projects.yaml`:

```yaml
projects:
  - name: example-production
    description: Production workloads
    business_unit: Technology
    business_impact: HBI
```

Supported project fields:

- `name` (required)
- `description` (optional)
- `business_unit` (optional, defaults to `Technology`)
- `business_impact` (optional, defaults to `MBI`)
- `is_folder` (optional, defaults to `false`)
- `parent_project_id` (optional)

## Usage

Set Terraform variables (for example through environment variables):

- `TF_VAR_wiz_url`
- `TF_VAR_wiz_auth_client_id`
- `TF_VAR_wiz_auth_client_secret`
- `TF_VAR_wiz_auth_audience` (optional, defaults to `wiz-api`)

Then run:

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan
terraform apply
```
