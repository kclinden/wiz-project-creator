locals {
  # Decode the YAML once, then build a name-keyed map for stable for_each keys.
  projects_config = yamldecode(file(var.projects_yaml_path))

  projects_by_name = {
    for project in try(local.projects_config.projects, []) :
    project.name => project
  }

  # Folders are created first; non-folders can reference these IDs as parents.
  folder_projects = {
    for name, project in local.projects_by_name :
    name => project if try(project.is_folder, false)
  }

  workload_projects = {
    for name, project in local.projects_by_name :
    name => project if !try(project.is_folder, false)
  }
}

resource "wiz-v2_project" "folders" {
  for_each = local.folder_projects

  name        = each.value.name
  slug        = replace(lower(try(each.value.slug, each.value.name)), "/[^a-z0-9]+/", "-")
  description = try(each.value.description, null)

  business_unit = try(each.value.business_unit, "Technology")
  identifiers   = try(each.value.identifiers, null)
  is_folder     = true

  # Keep legacy business_impact support while allowing full risk_profile overrides.
  risk_profile = merge(
    {
      business_impact = try(each.value.business_impact, "MBI")
    },
    try(each.value.risk_profile, {})
  )

  # Optional scoping/link blocks are passed through when present in YAML.
  tags                          = try(each.value.tags, null)
  resource_filter_links         = try(each.value.resource_filter_links, null)
  cloud_account_tags_links      = try(each.value.cloud_account_tags_links, null)
  cloud_account_links           = try(each.value.cloud_account_links, null)
  cloud_organization_links      = try(each.value.cloud_organization_links, null)
  kubernetes_cluster_tags_links = try(each.value.kubernetes_cluster_tags_links, null)
}

resource "wiz-v2_project" "workloads" {
  for_each = local.workload_projects

  name        = each.value.name
  slug        = replace(lower(try(each.value.slug, each.value.name)), "/[^a-z0-9]+/", "-")
  description = try(each.value.description, null)

  business_unit = try(each.value.business_unit, "Technology")
  identifiers   = try(each.value.identifiers, null)
  is_folder     = false
  # Parent precedence: explicit parent_project, legacy parent_project_id, then folder lookup by parent_project_name.
  parent_project = (
    try(each.value.parent_project, null) != null ?
    each.value.parent_project : (
      try(each.value.parent_project_id, null) != null ?
      each.value.parent_project_id :
      try(wiz-v2_project.folders[each.value.parent_project_name].id, null)
    )
  )

  # Keep legacy business_impact support while allowing full risk_profile overrides.
  risk_profile = merge(
    {
      business_impact = try(each.value.business_impact, "MBI")
    },
    try(each.value.risk_profile, {})
  )

  # Optional scoping/link blocks are passed through when present in YAML.
  tags                          = try(each.value.tags, null)
  resource_filter_links         = try(each.value.resource_filter_links, null)
  cloud_account_tags_links      = try(each.value.cloud_account_tags_links, null)
  cloud_account_links           = try(each.value.cloud_account_links, null)
  cloud_organization_links      = try(each.value.cloud_organization_links, null)
  kubernetes_cluster_tags_links = try(each.value.kubernetes_cluster_tags_links, null)
}
