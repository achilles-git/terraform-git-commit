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

variable "ssh_key_path" {
  type        = string
  default     = "~/.ssh/git_rsa"
  description = "Path to the git SSH Key file"
}

variable "paths" {
  type        = map(object({
    target = string
    data   = map(any)
  }))
  default     = {
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
