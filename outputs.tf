output "project_ids" {
  description = "Map of project names to Wiz project IDs."
  value       = { for name, project in wiz_project.this : name => project.id }
}
