output "project_ids" {
  # Useful for wiring created project IDs into downstream modules/workflows.
  description = "Map of project names to Wiz project IDs."
  value = merge(
    { for name, project in wiz-v2_project.folders : name => project.id },
    { for name, project in wiz-v2_project.workloads : name => project.id }
  )
}
