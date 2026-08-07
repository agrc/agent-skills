---
name: ugrc-python
description: Python coding guidance. Use when writing or reviewing Python scripts
---

Prefer the `pathlib` library over the older `os.path` module for handling filesystem paths. Be aware that the `arcpy` library does not support `pathlib.Path` objects directly prior to version 3.7; you will need to convert them to strings using `str(path)`. In version 3.7 and later, `arcpy` can handle `pathlib.Path` objects directly and can even be set to return them by default using this ArcPy environment setting:

```python
arcpy.env.returnPathlib = True
```

## Linting and Formatting

Use `ruff` for linting and formatting with the following configuration:

```toml
[tool.ruff.lint]
extend-select = ["I"]
```

If the current project does not implement this exact configuration, offer to migrate it and fix any resulting issues.

## CI Coverage

When a Python project uses Codecov, ensure that the test job which generates and uploads coverage runs on both pull requests and pushes to the default branch. Uploading coverage only from pull requests leaves Codecov's default-branch baseline stale, which produces reports stating that the base is many commits behind `main`.

When the same setup, lint, test, and coverage-upload steps appear in more than one workflow, extract them to a local composite action such as `.github/actions/test-and-coverage/action.yml`. Keep `actions/checkout` in each calling workflow because a local action is unavailable until the repository has been checked out. Pass the Codecov token to the action through a required input; do not embed repository secrets in the action definition.

## Packaging Migration

When a project uses a legacy `setup.py`, offer to migrate its packaging configuration to `pyproject.toml`; do not perform this migration automatically. If the user approves, make the migration in a separate commit from unrelated changes.

Preserve the existing package metadata, dependencies, optional dependency groups, and package-discovery configuration. Upgrade the build backend to Hatchling when the user approves: use `requires = ["hatchling"]` and `build-backend = "hatchling.build"`, then replace setuptools-specific configuration with the equivalent Hatchling configuration. Update CI cache dependency paths that reference `setup.py` to reference `pyproject.toml`. Remove obsolete `setup.py` configuration only after the declarative configuration is complete, and validate the migration by building source and wheel distributions and running the project's tests and Ruff checks.

When the version is stored only in a dedicated module, first confirm that no application code imports it. Then migrate that value to a static `version` field in `[project]`, remove `dynamic = ["version"]` and the setuptools dynamic-version configuration, and delete the unused module. Preserve a module that is part of the package's public runtime API.

Review declared console scripts during the migration. Remove an entry point only when its target is confirmed stale or nonexistent; otherwise preserve it in `[project.scripts]`.
