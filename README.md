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
    slug: example-production
    description: Production workloads
    business_unit: Technology
    business_impact: HBI
    identifiers: ["prod-001", "production"]
    risk_profile:
      business_impact: HBI
      is_actively_developed: "YES"
      has_authentication: "YES"
      has_exposed_api: "YES"
      is_internet_facing: "YES"
      is_customer_facing: "YES"
      stores_data: "YES"
      is_regulated: "YES"
      sensitive_data_types: ["PII", "PCI"]
      regulatory_standards: ["GDPR", "SOC"]
    tags:
      - key: env
        value: production
    resource_filter_links:
      - environment: PRODUCTION
        resource_tags_v3:
          equals_any:
            - key_equals: env
              value_equals: prod
    cloud_account_tags_links:
      - environment: PRODUCTION
        shared: false
        cloud_account_tags_v3:
          equals_any:
            - key_equals: environment
              value_equals: production
    cloud_account_links:
      - cloud_account: <cloud-account-id>
        environment: PRODUCTION
        shared: true
    kubernetes_cluster_tags_links:
      - environment: PRODUCTION
        shared: false
        kubernetes_cluster_tags:
          - key: cluster-role
            value: production
        cluster_filters:
          namespace_names_v2:
            equals: ["app", "api", "web"]
```

Supported project fields:

- `name` (required)
- `slug` (optional, defaults to a slug generated from `name`)
- `description` (optional)
- `business_unit` (optional, defaults to `Technology`)
- `identifiers` (optional)
- `risk_profile` (optional object, merged with default `business_impact = MBI`)
- `business_impact` (optional legacy shortcut for `risk_profile.business_impact`)
- `tags` (optional)
- `resource_filter_links` (optional)
- `cloud_account_tags_links` (optional)
- `cloud_account_links` (optional)
- `kubernetes_cluster_tags_links` (optional)
- `is_folder` (optional, defaults to `false`)
- `parent_project` (optional)
- `parent_project_id` (optional legacy alias)
- `parent_project_name` (optional, resolves parent from another project `name` in the same YAML file)

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
