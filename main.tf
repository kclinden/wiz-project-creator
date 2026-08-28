locals {
  projects_config = yamldecode(file(var.projects_yaml_path))

  projects_by_name = {
    for project in try(local.projects_config.projects, []) :
    project.name => project
  }
}

resource "wiz_project" "this" {
  for_each = local.projects_by_name

  name              = each.value.name
  description       = try(each.value.description, null)
  business_unit     = try(each.value.business_unit, "Technology")
  is_folder         = try(each.value.is_folder, false)
  parent_project_id = try(each.value.parent_project_id, null)

  risk_profile {
    business_impact = try(each.value.business_impact, "MBI")
  }
}
