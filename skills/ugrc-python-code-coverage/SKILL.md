---
name: ugrc-python-code-coverage
description: Python test coverage and Codecov CI guidance. Use when configuring, reviewing, or troubleshooting coverage workflows for Python projects.
---

When a Python project uses Codecov, ensure that the test job which generates and uploads coverage runs on both pull requests and pushes to the default branch. Uploading coverage only from pull requests leaves Codecov's default-branch baseline stale, which produces reports stating that the base is many commits behind `main`.

When the same setup, lint, test, and coverage-upload steps appear in more than one workflow, extract them to a local composite action such as `.github/actions/test-and-coverage/action.yml`. Keep `actions/checkout` in each calling workflow because a local action is unavailable until the repository has been checked out. Pass the Codecov token to the action through a required input; do not embed repository secrets in the action definition.
