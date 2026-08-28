locals {
  # Load the project catalog from YAML once at plan time. Centralizing the decode
  # here avoids repeating file/yamldecode logic in multiple resources.
  projects_config = yamldecode(file(var.projects_yaml_path))

  projects_by_name = {
    for project in try(local.projects_config.projects, []) :
    project.name => project
  }

  # Split the catalog into folders and non-folders so dependency direction is
  # always one-way (workloads depend on folders, never the reverse). This avoids
  # graph cycles when parent_project_name points to another project in the same
  # YAML document.
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

  name = each.value.name
  # Enforce lowercase and normalize separators to satisfy Wiz slug constraints
  # even when a mixed-case slug/name is supplied in YAML.
  slug        = replace(lower(try(each.value.slug, each.value.name)), "/[^a-z0-9]+/", "-")
  description = try(each.value.description, null)

  business_unit = try(each.value.business_unit, "Technology")
  identifiers   = try(each.value.identifiers, null)
  is_folder     = true

  # Preserve backwards compatibility for configs that only set business_impact,
  # while still allowing full risk_profile fields when provided.
  risk_profile = merge(
    {
      business_impact = try(each.value.business_impact, "MBI")
    },
    try(each.value.risk_profile, {})
  )

  # Pass through optional project linkage/scoping blocks directly from YAML.
  # Using try(..., null) keeps absent keys optional and avoids noisy defaults.
  tags                          = try(each.value.tags, null)
  resource_filter_links         = try(each.value.resource_filter_links, null)
  cloud_account_tags_links      = try(each.value.cloud_account_tags_links, null)
  cloud_account_links           = try(each.value.cloud_account_links, null)
  cloud_organization_links      = try(each.value.cloud_organization_links, null)
  kubernetes_cluster_tags_links = try(each.value.kubernetes_cluster_tags_links, null)
}

resource "wiz-v2_project" "workloads" {
  for_each = local.workload_projects

  name = each.value.name
  # Apply the same slug normalization as folder projects for consistent naming.
  slug        = replace(lower(try(each.value.slug, each.value.name)), "/[^a-z0-9]+/", "-")
  description = try(each.value.description, null)

  business_unit = try(each.value.business_unit, "Technology")
  identifiers   = try(each.value.identifiers, null)
  is_folder     = false
  # Parent precedence is intentionally explicit:
  # 1) parent_project (preferred direct id)
  # 2) parent_project_id (legacy alias)
  # 3) parent_project_name (lookup in folder resource map)
  # This allows both legacy and modern YAML structures while keeping references
  # deterministic and cycle-free.
  parent_project = (
    try(each.value.parent_project, null) != null ?
    each.value.parent_project : (
      try(each.value.parent_project_id, null) != null ?
      each.value.parent_project_id :
      try(wiz-v2_project.folders[each.value.parent_project_name].id, null)
    )
  )

  # Preserve backwards compatibility for configs that only set business_impact,
  # while still allowing full risk_profile fields when provided.
  risk_profile = merge(
    {
      business_impact = try(each.value.business_impact, "MBI")
    },
    try(each.value.risk_profile, {})
  )

  # Pass through optional project linkage/scoping blocks directly from YAML.
  # Using try(..., null) keeps absent keys optional and avoids noisy defaults.
  tags                          = try(each.value.tags, null)
  resource_filter_links         = try(each.value.resource_filter_links, null)
  cloud_account_tags_links      = try(each.value.cloud_account_tags_links, null)
  cloud_account_links           = try(each.value.cloud_account_links, null)
  cloud_organization_links      = try(each.value.cloud_organization_links, null)
  kubernetes_cluster_tags_links = try(each.value.kubernetes_cluster_tags_links, null)
}
