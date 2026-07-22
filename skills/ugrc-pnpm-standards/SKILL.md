---
name: ugrc-pnpm-standards
description: Upgrades a project to PNPM 11 and enforces UGRC NPM best practices. Use when migrating from PNPM 10, refreshing pnpm-lock.yaml, removing .npmrc, pinning pnpm@11 in GitHub Actions, or upgrading agrc/firebase-website-deploy-composite-action to v2.
---

You can assume that PNPM v11 is already installed globally on the system.

Make sure that the project is upgraded to PNPM v11 by running the following command: `pnpx codemod run pnpm-v10-to-v11`

Make sure this project follows our NPM best practices document.

Fetch it with:
curl -L 'https://docs.google.com/document/d/1imxpULirpXjarj2JVPqh1O1i3T4x5VSLzQZ832QDTbI/export?format=txt'

If the webpage fetch tool fails or only returns a redirect, do not retry the redirected URL. Use the `curl -L` command above and treat that output as the source of truth.

Make sure that we're pointing to PNPM version `11` rather than `latest` in the GitHub Actions workflows.

No need to add the `packageManager` field to `package.json` if it's not already there, but if it is there, make sure it says `pnpm@11`.

When you're done, run `rm -rf node_modules && rm pnpm-lock.yaml && pnpm i` to make sure that the lockfile is updated and that there are no issues with the new version of PNPM.

Do NOT create an .npmrc file if the project uses PNPM. In fact, if there is an .npmrc file and the project uses PNPM, please delete it.

Upgrade agrc/firebase-website-deploy-composite-action to v2 if needed. Handle the following breaking change when moving from v1 to v2: "the actions/checkout step has been removed from this action to allow for more flexibility between checkout and this action running. Migration instructions: Add checkout to the parent workflow before executing this step."
