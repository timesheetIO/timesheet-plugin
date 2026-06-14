# Timesheet CLI Skill

[![skills.sh](https://skills.sh/b/timesheetIO/timesheet-plugin)](https://skills.sh/timesheetIO/timesheet-plugin)

A Claude Code plugin (and portable agentic skill) for controlling [timesheet.io](https://timesheet.io) time tracking through the `@timesheet/cli` command-line tool. The skill gives any skills-aware agent (Claude Code, Clawdbot, or anything that loads `SKILL.md` files) structured knowledge of every CLI command, flag, and common workflow.

## Prerequisites

Install the CLI globally:

```bash
npm install -g @timesheet/cli
```

Authenticate once via OAuth:

```bash
timesheet auth login
```

Or set an API key for automation:

```bash
export TIMESHEET_API_KEY=ts_your.apikey
```

## Installation

### Claude Code

**Recommended: install from the plugin marketplace.**

```
/plugin marketplace add timesheetIO/timesheet-plugin
/plugin install timesheet@timesheet
```

This repository is a self-contained marketplace: `.claude-plugin/marketplace.json` lists a single plugin whose source is the repo root, so adding the marketplace and installing the plugin pulls in the skill directly.

**Or install from the bundled CLI** (no Git access required):

```bash
timesheet skill install            # ~/.claude/skills/timesheet
timesheet skill install --project  # ./.claude/skills/timesheet
timesheet skill install --force    # overwrite if present
```

**Or copy manually:**

```bash
mkdir -p ~/.claude/skills
cp -r skills/timesheet ~/.claude/skills/
```

After install, invoke with `/timesheet` or let the model pick it up from natural-language requests.

### Clawdbot

Workspace skills:

```bash
cp -r skills/timesheet <your-workspace>/skills/
```

User skills:

```bash
cp -r skills/timesheet ~/.clawdbot/skills/
```

Or, with the CLI installed: `timesheet skill install --clawdbot`.

Or register via `extraDirs` in `~/.clawdbot/clawdbot.json`:

```json
{
  "skills": {
    "load": {
      "extraDirs": ["/path/to/this/skills"]
    }
  }
}
```

### Any agent (skills.sh CLI)

Install into any supported agent (Claude Code, Codex, Cursor, OpenCode, and more) with the [`skills`](https://github.com/vercel-labs/skills) CLI:

```bash
npx skills add timesheetIO/timesheet-plugin
```

### Other agents

Any tool that reads a single `SKILL.md` with YAML frontmatter can consume the skill. Point it at `skills/timesheet/SKILL.md` and the agent gets the full command reference.

## Usage

### As a slash command

```
/timesheet
```

### Natural language

- "Start a timer for project X"
- "What is my timer status?"
- "Show my tasks for today"
- "Create an expense of 42 EUR on task <id>"
- "Approve the pending absence <id>"
- "List my organizations and their members"

## Capabilities

| Category | Commands |
|----------|----------|
| **Auth** | login, logout, status, apikey |
| **Timer** | start, stop, pause, resume, status, update |
| **Tasks** | list, show, create, update, delete |
| **Projects** | list, show, create, update, delete, members (list/add/update/remove) |
| **Teams** | list, members (list/add/update/remove/status) |
| **Organizations** | list, show, create, update, delete, members (list/show/add/update/remove) |
| **Contracts** | list, show, create, update, delete, activate, suspend, reactivate, terminate |
| **Absences** | list, show, create, update, delete, approve, reject, cancel |
| **Absence types** | list, show, create, update, delete |
| **Todos** | list, show, create, update, close, reopen, delete |
| **Tags** | list, show, create, update, delete |
| **Notes** | list, show, create, update, delete, file-url |
| **Expenses** | list, show, create, update, delete, refund, file-url |
| **Pauses** | list, show, create, update, delete |
| **Rates** | list, show, create, update, delete |
| **Reports** | summary, export |
| **Profile** | show, update, settings, settings-update |
| **Config** | show, set, reset |

## Plugin structure

```
timesheet-plugin/
├── .claude-plugin/
│   ├── marketplace.json  # marketplace catalog (one plugin, source ".")
│   └── plugin.json       # Claude Code plugin manifest
├── skills/
│   └── timesheet/
│       └── SKILL.md      # YAML frontmatter + command reference
└── README.md
```

## Configuration

Configure environment per agent. Example for Clawdbot:

```json
{
  "skills": {
    "entries": {
      "timesheet": {
        "enabled": true,
        "env": {
          "TIMESHEET_API_KEY": "ts_your.apikey"
        }
      }
    }
  }
}
```

For Claude Code, export `TIMESHEET_API_KEY` in your shell profile or rely on `timesheet auth login`.

## Links

- [timesheet.io](https://timesheet.io)
- [@timesheet/cli on npm](https://www.npmjs.com/package/@timesheet/cli)
- [Claude Code skills docs](https://docs.claude.com/en/docs/claude-code/skills)
- [Claude Code plugin marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Clawdbot skills docs](https://docs.clawd.bot/tools/skills)

## License

MIT
