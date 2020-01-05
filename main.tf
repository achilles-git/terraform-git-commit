locals {
  git_clone_trigger  = uuid()
  file_source_keys   = keys(var.paths)
  content_hash       = var.changes ? md5(join("\n", local_file.rendered.*.content)) : 1
  templates_root_dir = var.templates_root_dir == "" ? abspath(path.module) : var.templates_root_dir
  repository_remote  = format("git@%s:%s/%s.git", var.git_base_url, var.git_organization, var.git_repository)
  repository_dir     = format("%s/repository", path.module)
}

resource "null_resource" "clone" {
  count      = var.enabled ? 1 : 0
  depends_on = [var.commit_depends_on]
  
  provisioner "local-exec" {
    command = "${path.module}/scripts/clone.sh ${local.repository_remote} ${local.repository_dir} ${var.ssh_key_file}"
  }

  triggers = {
    hash = local.git_clone_trigger
  }
}

resource "local_file" "rendered" {
  depends_on = [null_resource.clone]
  count      = var.enabled ? length(local.file_source_keys) : 0
  filename   = format("%s/%s", local.repository_dir, lookup(var.paths[local.file_source_keys[count.index]], "target"))
  content    = templatefile(format("%s/%s", local.templates_root_dir, element(local.file_source_keys, count.index)), lookup(var.paths[local.file_source_keys[count.index]], "data"))
}

resource "null_resource" "checkout" {
  count      = var.branch == "master" || !var.enabled ? 0 : 1
  depends_on = [null_resource.clone]

  provisioner "local-exec" {
    command = "${path.module}/scripts/checkout.sh ${local.repository_dir} ${var.branch}"
  }

  triggers = {
    hash = local.git_clone_trigger
  }
}

resource "null_resource" "commits" {
  count      = var.enabled ? 1 : 0
  depends_on = [
    local_file.rendered,
    null_resource.checkout,
  ]

  provisioner "local-exec" {
    command = "${path.module}/scripts/commit.sh ${local.repository_dir} ${var.branch} '${var.message}' ${var.ssh_key_file}"
  }

  triggers = {
    content_hash = local.content_hash
  }
}

resource "null_resource" "cleanup" {
  count      = var.enabled ? 1 : 0
  depends_on = [
    null_resource.clone,
    null_resource.commits,
  ]

  provisioner "local-exec" {
    command = "rm -rf ${local.repository_dir}"
  }

  triggers = {
    hash = local.git_clone_trigger
  }
}

