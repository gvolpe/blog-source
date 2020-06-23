let GithubActions =
      https://raw.githubusercontent.com/gvolpe/github-actions-dhall/steps/cachix/package.dhall sha256:4cd8f64770d8b015c2fd52bae5ddfb5b393eb7e0936f7f8e18f311c591b888a5

let setup =
      [ GithubActions.steps.checkout
      , GithubActions.steps.cachix/install-nix
      , GithubActions.steps.cachix/cachix { cache-name = "gvolpe-blog" }
      , GithubActions.steps.run
          { run = "nix-shell --run \"bundle install && bundle exec jekyll build\"" }
      ]

in  GithubActions.Workflow::{
    , name = "Blog"
    , on = GithubActions.On::{
      , pull_request = Some GithubActions.PullRequest::{=}
      , push = Some GithubActions.Push::{ branches = Some [ "master" ] }
      }
    , jobs = toMap
        { build = GithubActions.Job::{
          , name = "build"
          , needs = None (List Text)
          , runs-on = GithubActions.types.RunsOn.`ubuntu-18.04`
          , steps = setup
          }
        }
    }