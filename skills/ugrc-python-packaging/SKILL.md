---
name: ugrc-python-packaging
description: Python packaging migration guidance. Use when reviewing or migrating projects from setup.py to pyproject.toml, including Hatchling, dependencies, versioning, and console scripts.
---

When a project uses a legacy `setup.py`, offer to migrate its packaging configuration to `pyproject.toml`; do not perform this migration automatically. If the user approves, make the migration in a separate commit from unrelated changes.

Preserve the existing package metadata, dependencies, optional dependency groups, and package-discovery configuration. Upgrade the build backend to Hatchling when the user approves: use `requires = ["hatchling"]` and `build-backend = "hatchling.build"`, then replace setuptools-specific configuration with the equivalent Hatchling configuration. Update CI cache dependency paths that reference `setup.py` to reference `pyproject.toml`. Remove obsolete `setup.py` configuration only after the declarative configuration is complete, and validate the migration by building source and wheel distributions and running the project's tests and Ruff checks.

Put all testing and build dependencies in `[project.optional-dependencies]` under a `dev` group, and remove any `tests` group. Make sure to update any documentation that references the `tests` group to reference the `dev` group instead.

When the version is stored only in a dedicated module migrate that value to a static `version` field in `[project]`, remove `dynamic = ["version"]` and the setuptools dynamic-version configuration, and delete the unused module. Fix any imports of the old version module using the following pattern:

Resolve the version once in your top-level __init__.py file using importlib.metadata, and then import that version attribute across your other modules.
In the root __init__.py (e.g., uocc_skid/__init__.py)

```python
from importlib.metadata import version
try:
    # Use distribution name as defined in pyproject.toml
    __version__ = version("uocc-skid")
except PackageNotFoundError:
    # Fallback when running from raw source tree without installation
    __version__ = "0.0.0-dev"
```

Then in other modules, import the version attribute from the top-level package:

```python
from uocc_skid import __version__
```

Clean up any remaining references to the old version module in the codebase, including in CI workflows and documentation.

Review declared console scripts during the migration. Remove an entry point only when its target is confirmed stale or nonexistent; otherwise preserve it in `[project.scripts]`.
