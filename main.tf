resource "github_team" "review_team" {
  name        = "${var.repo} reviewers"
  description = "The team responsible for approving changes to ${var.repo}"
  privacy     = "closed"
}

resource "github_team_membership" "repo_reviewers_membership" {
  team_id  = "${github_team.review_team.id}"
  count    = "${length(var.reviewers)}"
  username = "${element(var.reviewers, count.index)}"
  role     = "member"
}

resource "github_team_repository" "team_repository" {
  team_id    = "${github_team.review_team.id}"
  repository = "${var.repo}"
  permission = "push"
}

resource "github_branch_protection" "repo_branch" {
  repository = "${var.repo}"
  count      = "${length(var.branches)}"
  branch     = "${element(var.branches, count.index)}"
  depends_on = ["github_team.review_team"]

  required_status_checks {
    strict   = "${var.required_status_checks_strict}"
    contexts = "${var.required_contexts}"
  }

  required_pull_request_reviews {
    require_code_owner_reviews = true
    dismiss_stale_reviews      = true

    # we would like to reference github_team.review_team but dismissal teams is expecting the format lower(repo name)-reviewers
    dismissal_teams = ["${lower(var.repo)}-reviewers"]
  }
}
