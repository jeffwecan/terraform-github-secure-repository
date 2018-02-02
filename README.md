# Terraform Module: GitHub Secure Repository

This repo contains a [Terraform] Module that helps setup secure protections for an existing GitHub repository. The module creates a GitHub team and associates it with an existing Repository as a review team and setups other desired branch protections. It is meant to streamline leveraging GitHub's [CODEOWNERS] feature to help ensure a secure/compliant workflow.

## Table of Contents

- [Requirements](#requirements)
- [Dependencies](#dependencies)
- [Usage](#usage)
  - [Module Variables](#module-variables)
  - [Module Outputs](#module-outputs)
- [License](#license)

## Requirements

This module requires version `>=0.10.0` of Terraform.

This module requires version `>=1.0.0` of the GitHub provider.

## Dependencies

This module depends on a correctly configured [GitHub Provider].

## Usage

```hcl
module "repo-protections" {
  source    = "github.com/wpengine/terraform-github-secure-repo?ref=0.1.0"
  repo_name = "org/example-repo"

  reviewers = [
    "fantasticdev1", # Joe Smith
    "terribledev1",  # Billy Bob
  ]

  branches  = ["master"]
}
```

The above would:
 - Create a GitHub team named "example-repo reviewers" containing only Joe Smith and Billy Bob as members.
 - Protect the master branch (Disable force pushes and prevent deletion)
 - Require reviews for all pull requests to master
 - Require that the review came from a [CODEOWNERS] member
 - Restrict who can dismiss stale pull requests to a member of the [CODEOWNERS]
 - Require status checks to pass before merging

If you want to require specific tests to pass before merging, you can specify required_contexts to match what your CI system reports. For example:


```hcl
module "repo-protections" {
  source    = "github.com/wpengine/terraform-github-secure-repo?ref=0.1.0"
  repo_name = "org/example-repo"

  reviewers = [
    "fantasticdev1", # Joe Smith
    "terribledev1",  # Billy Bob
  ]

  branches  = ["master"]
  required_contexts = ["continuous-integration/jenkins/pr-merge"]
}
```

would do the same as the above, but disallow merging until passing Jenkins tests were present.

The other half of this is ensuring a valid CODEOWNERS file is present in the repo, and unfortunately Terraform can't help you there. You should ensure the following is present in a `.github/CODEOWNERS` file for all branches you specify above.

```bash
# This team is responsible for reviewing all changes to example-repo
* @org_name/example-repo-reviewers
```

### Module Variables

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| repo | The name of the repo to add a review team and branch protections to. | string | - | yes |
| reviewers | List of github users to add to the repo's review team. | list | - | yes |
| branches | List of branches to add branch protections to. | list | ['develop', 'master'] | no |
| required_contexts | List of required status check contexts to require. | list | - | yes |
| required_status_checks_strict | Boolean: Require branches to be up to date before merging | string | false | no |

### Module Outputs

Available outputs:

| variable | description |
| -------- | ----------- |
| review_team_id | The ID of the created GitHub team

## License

This code is released under the Apache 2.0 License. Please see [LICENSE] for more details.

[Terraform]: https://www.terraform.io/
[CODEOWNERS]: https://help.github.com/articles/about-codeowners/
[GitHub Provider]: https://www.terraform.io/docs/providers/github/index.html
[LICENSE]: LICENSE
