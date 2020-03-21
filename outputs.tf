output "content_hash" {
  value = local.content_hash
}

output "done_trigger" {
  value       = join("", null_resource.commit.*.triggers.hash)
  description = "As this references the cleanup resources you can rely on it to determine the commits are made."
}
