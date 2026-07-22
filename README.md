# agent-skills

A central repository for UGRC agent skills.

## Overview

This repository is the single source of truth for UGRC's custom GitHub Copilot slash commands ("Agent Skills"). It combines the open [Agent Skills specification](https://agentskills.io/specification) with [skills.sh](https://skills.sh), a declarative package manager for AI instructions. Rather than copying prompt files into every codebase, skills are tracked here and downloaded/cached globally on team machines via the `skills` CLI, leaving application repositories untouched.

> [!NOTE]
> These skills are only available to local Copilot chat inside VS Code. GitHub's Cloud Agent (browser-based chats on GitHub.com, automated code reviews, and PR tasks) cannot access them unless the skill files live in each repository or the organization upgrades to GitHub Enterprise.

## Workflow Roles

| Role                         | Core Responsibilities                                                                                                  |
| ---------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Skill User (Developer)**   | Run the one-time local setup, invoke slash commands during everyday coding, and pull skill updates when notified.      |
| **Skill Developer (Author)** | Build, sandbox, and refine YAML/Markdown files in this centralized repository and push approved changes to production. |

## Installing Team Skills for Skill Users

```bash
pnpm dlx skills add agrc/agent-skills
```

After installation:

1. **List commands:** Type `/skills list` in the Copilot chat window to see which commands are active.
2. **Run a skill:**
   - Some skills activate automatically when your prompt matches their description.
   - You can force-trigger a specific workflow by typing its slash command (e.g., `/ugrc-skill-name`). All UGRC skill names are prefixed with `ugrc-`.
3. **Update:** Pull the latest skills with:

   ```bash
   pnpm dlx skills update
   ```

## 🛠️ How to Create a New Skill

All slash commands and custom workflows in this repository strictly adhere to the open [Agent Skills specification](https://agentskills.io/specification).

### 1. Local "Hot-Reload" Testing Loop

Skill authors should **not** install these skills via the `skills` CLI. Instead, follow this local workflow:

1. Clone this repository and check out a feature branch.
2. Add the `skills/` folder path from this project to your "Chat: Agent Skills Locations" VS Code settings. Leave the other default directories in place.
3. Open an active application repository where you intend to run test prompts.
4. Edit the `SKILL.md` inside your local `agent-skills` folder, press **Save**, and immediately re-trigger the slash command in chat. Copilot dynamically reads the updated instructions without requiring an editor restart. No need to restart the chat window or open a new chat.
5. Commit your changes and open a pull request for review.

---

### 2. Folder Structure & Naming Rules

Every skill must reside in its own dedicated subfolder inside the `skills/` directory and contain an entry file named exactly `SKILL.md`:

```text
agent-skills/
├── skills/
│   └── ugrc-your-skill-name/  <-- Parent directory (must match frontmatter 'name')
│       ├── SKILL.md           <-- Required: metadata + instructions
│       ├── assets/            <-- (Optional) Templates, images, data files
│       ├── references/        <-- (Optional) Sidecar samples, schemas, or templates
│       └── scripts/           <-- (Optional) Automated scripts invoked by the agent
```

> [!WARNING]
> Strict Naming Constraint: The frontmatter `name` property and parent folder name must match exactly and be **1–64 characters** containing only lowercase letters, numbers, and hyphens (e.g., `webapp-testing`, NOT `Webapp_Testing` or `webappTesting`). It cannot start or end with a hyphen or contain consecutive hyphens. All skill names in this project should start with the `ugrc-` prefix.

### 3. Writing the `SKILL.md` file

Every `SKILL.md` file requires a specific YAML frontmatter block at the very top, followed by a markdown body containing the core instructions.

```markdown
---
name: ugrc-your-skill-name
description: Generates automated e2e Playwright coverage blocks for React components. Use when writing testing suites.
---

# Operational Role

Act as our principal QA Automation Engineer...

# Strict Constraints

- Always use the Page Object Model pattern.
- Never hardcode authentication tokens.
```

#### 💡 Frontmatter Best Practices

The Agent Skills specification requires only `name` and `description`. The remaining fields are optional and should be added only when they provide useful context.

| Field           | Required | Notes                                                                                                                                  |
| --------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| `name`          | Yes      | 1–64 characters; forms the slash command (e.g., `/ugrc-your-skill-name`). Must match the parent folder name and start with `ugrc-`.    |
| `description`   | Yes      | 1–1024 characters; describe what the skill does **and** when to use it. Include keywords so the agent can match prompts automatically. |
| `license`       | No       | License name or reference to a bundled license file.                                                                                   |
| `compatibility` | No       | Max 500 characters; note required tools, products, or environment constraints.                                                         |
| `metadata`      | No       | Key-value map for custom properties (e.g., `author`, `version`).                                                                       |
| `allowed-tools` | No       | Experimental; space-separated list of pre-approved tools.                                                                              |

> [!NOTE]
> Follow the best practices found on the [Agent Skills website](https://agentskills.io/skill-creation/best-practices).

---

### 4. Validation & CI Quality Gates

Validate your skill locally with the official reference validator before opening a PR:

```bash
pnpm dlx skills-ref validate ./skills/ugrc-your-skill-name
```

---

## Strategic Future Outlook: GitHub Enterprise

The major drawback of the current approach is that GitHub's Cloud Agent has no access to these centralized skills. Enabling cloud access would require checking skill files into every repository or upgrading to GitHub Enterprise.

### Current Strategy: Remaining on the Free Tier

UGRC's GitHub organization is public and runs on GitHub's free tier. Moving to Enterprise would force every organization seat onto a foundational Enterprise license (typically $21+ per user/month) in addition to Copilot premiums. To preserve a $0 base operating model, the localized `skills.sh` architecture remains our primary approach.
