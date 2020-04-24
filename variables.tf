variable "git_organization" {
  type        = string
  description = "The git organization or individual, owner of the repository"
}

variable "git_repository" {
  type        = string
  description = "The git repository name"
}

variable "git_base_url" {
  type        = string
  default     = "github.com"
  description = "Base url to the git remote"
}

variable "git_user" {
  type        = string
  default     = "git"
  description = "Username or username-password authentication"
}

variable "ssh_key_file" {
  type        = string
  default     = "~/.ssh/git_rsa"
  description = "Path to the git SSH Key file"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "When not enabled no resources will be created or committed"
}

variable "paths" {
  type = any
  default = {
    "." = {
      target = ".",
      data   = {}
    }
  }
  description = "Map of source and targets paths to add changes for"
}

variable "message" {
  type        = string
  description = "Commit message"
}

variable "branch" {
  type        = string
  default     = "master"
  description = "The branch to commit and push the changes to"
}

variable "changes" {
  type        = bool
  default     = true
  description = "On changes a new branch can be opened containing the changes"
}

variable "repository_checkout_dir" {
  type        = string
  default     = "/conf/git/checkout"
  description = "Path to directory to checkout git repository"
}


variable "templates_root_dir" {
  type        = string
  default     = ""
  description = "The root directory to find template files. Defaults to current module directory"
}

variable "commit_depends_on" {
  type        = list
  default     = []
  description = "Terraform resources to depend on before adding the commits"
}
