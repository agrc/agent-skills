---
name: ugrc-upgrade-tailwind-v4
description: Use this to upgrade to Tailwind CSS v4
---

# Migrate Project

1. Verify the project currently uses Tailwind CSS. If not, stop and inform the user that this rule only applies to existing Tailwind projects.
2. Check the current Tailwind CSS version. If the project is on v2 or earlier, stop and inform the user that they must first upgrade to v3 before proceeding to v4.
3. Upgrade to Tailwind CSS v4 by fetching and following the official migration guide: #fetch https://tailwindcss.com/docs/upgrade-guide. Make sure that you are using the vite plugin and not the postcss plugin.
4. Make sure that the `@ugrc/tailwind-preset` and `@ugrc/utah-design-system` packages are also upgraded to the latest versions.
5. After completing the migration, run the project build and fix any compilation errors related to Tailwind.

## Remove Dependabot Ignore Rules

Use the GitHub CLI to find and remove any Tailwind-related Dependabot ignore rules that were created through PR comments in this repository. The goal is to unignore every Tailwind-related package that Dependabot is currently suppressing because of prior PR comment commands.

Audit Dependabot PR history for Tailwind-related packages.

Use this order:

1. Check `.github/dependabot.yml` for `ignore` rules affecting `tailwindcss`, `@tailwindcss/*`, `postcss`, `autoprefixer`, and `prettier-plugin-tailwindcss`.
2. Query Dependabot PRs with `gh pr list`, not `gh search prs`.
3. Prefer:
   - `gh pr list --search "author:app/dependabot" --state all --json number,title,url,headRefName,state`
   - then inspect likely grouped PRs with `gh pr view <number> --json body,comments,url`
   - or `gh pr view <number> --comments`
4. Search PR bodies and comments for these terms:
   - `tailwind`
   - `tailwindcss`
   - `@tailwindcss`
   - `postcss`
   - `autoprefixer`
   - `prettier-plugin-tailwindcss`
   - `@dependabot ignore`
   - `@dependabot unignore`
   - `@dependabot recreate`
5. Do not rely only on PR titles, because grouped PRs often hide package names in the body.
6. Avoid `cat` for paging; use `sed -n`, `tail -n`, `rg -n`, or `gh pr view --json ... | rg ...`.

Return:

- whether the package appears in repo config ignores
- which PRs included the package
- whether any ignore/unignore command exists in comments
- the exact unignore command to post, or say explicitly that no ignore state was found
