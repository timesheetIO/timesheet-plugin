# Timesheet plugin

[![skills.sh](https://skills.sh/b/timesheetIO/timesheet-plugin)](https://skills.sh/timesheetIO/timesheet-plugin)

Track your time in [timesheet.io](https://timesheet.io) from Claude: start and stop timers, log past work, and manage projects, tasks, absences, contracts, expenses, todos, and team data. The plugin includes:

- **Timesheet connector**: the Timesheet MCP server at `https://mcp.timesheet.io`. Sign in with your Timesheet account the first time you use it. It works in Claude Code, on claude.ai, and in Cowork, and needs nothing installed.
- **Timesheet skill**: a portable agentic skill for the `@timesheet/cli` command-line tool. It gives any skills-aware agent (Claude Code, Clawdbot, or anything that loads `SKILL.md` files) structured knowledge of every CLI command, flag, and common workflow.
- **Commands** for everyday steps: start and stop the timer, check today's hours, log finished work, and see the week. See [Usage](#usage).
- **Agents**: a reporter that sums up your hours for a period, and a reviewer that checks your entries for gaps, overlaps, and missing descriptions. They run in Claude Code and Cowork.
- **Session reminders** in Claude Code and Cowork: the plugin notes when each session starts. When your last session in a folder ran 15 minutes or more and no time was logged, it reminds you at the next start. Turn them off with `/plugin configure timesheet@timesheet` or in `/config`.

## Prerequisites

The connector needs only a Timesheet account. For the skill, install the CLI globally:

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

This repository is a self-contained marketplace: `.claude-plugin/marketplace.json` lists a single plugin whose source is the repo root, so adding the marketplace and installing the plugin pulls in the connector and the skill directly. To sign in, run `/mcp`, select the Timesheet server, and follow the sign-in steps.

**Or install only the skill from the bundled CLI** (no Git access required):

```bash
timesheet skill install            # ~/.claude/skills/timesheet
timesheet skill install --project  # ./.claude/skills/timesheet
timesheet skill install --force    # overwrite if present
```

**Or copy the skill manually:**

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

### Commands

| Command | What it does |
|---------|--------------|
| `/timesheet:start [project] [description]` | Starts the timer for a project |
| `/timesheet:stop [description]` | Stops the timer and saves the entry |
| `/timesheet:status` | Shows the timer and today's hours |
| `/timesheet:log [project] [time] [description]` | Adds a finished entry, also for this or the last session |
| `/timesheet:week [last]` | Shows this week's or last week's hours by project |

### Agents

- `timesheet:reporter` builds a report for a period, with hours by project, billable time, and an optional export.
- `timesheet:reviewer` checks the entries of a period for gaps, overlaps, missing descriptions, very long entries, and unbilled work. It reports what to fix and changes nothing.

Ask for them in your own words, such as "review my timesheet for last week", or with `@agent-timesheet:reviewer`.

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
├── .mcp.json             # Timesheet connector (MCP server)
├── agents/               # reporter and reviewer
├── commands/             # start, stop, status, log, week
├── hooks/
│   └── hooks.json        # session reminders
├── scripts/              # the session reminder scripts
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
- [Timesheet MCP server docs](https://docs.timesheet.io/integrations/mcp-server/)
- [@timesheet/cli on npm](https://www.npmjs.com/package/@timesheet/cli)
- [Claude Code skills docs](https://docs.claude.com/en/docs/claude-code/skills)
- [Claude Code plugin marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Clawdbot skills docs](https://docs.clawd.bot/tools/skills)

## License

MIT
