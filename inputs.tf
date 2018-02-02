variable "repo" {
  description = "The name of the repo to add a review team and branch protections to."
}

variable "reviewers" {
  type        = "list"
  description = "List of github users to add to the repo's review team."
}

variable "branches" {
  type        = "list"
  default     = ["develop", "master"]
  description = "List of branches to add branch protections to."
}

variable "required_contexts" {
  type        = "list"
  description = "List of required status check contexts to require."
}

variable "required_status_checks_strict" {
  type        = "string"
  description = "Boolean: Require branches to be up to date before merging"
  default     = "false"
}
