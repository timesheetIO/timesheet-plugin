# Timesheet plugin

[![skills.sh](https://skills.sh/b/timesheetIO/timesheet-plugin)](https://skills.sh/timesheetIO/timesheet-plugin)

Track your time in [Timesheet](https://timesheet.io) from your AI agent: start and stop the timer, log finished work, see your hours by project, and manage projects, tasks, absences, contracts, expenses, todos, and team data. The plugin works in Claude Code, Cowork, and Cursor. The skill on its own works in any agent that loads `SKILL.md` files.

## What the plugin contains

| Part | What it does | Works in |
|------|--------------|----------|
| **Timesheet connector** | The Timesheet MCP server at `https://mcp.timesheet.io`. It gives the agent tools for the timer, time entries, projects, reports and exports, absences, and team data. It needs nothing installed. | Claude Code, claude.ai, Cowork, Cursor |
| **Timesheet skill** | Tells the agent how to work with Timesheet: with the connector's tools when they are there, and with the `@timesheet/cli` command-line tool otherwise. | Claude Code, Cowork, Cursor, and any agent that loads skills |
| **Commands** | Five everyday steps: start and stop the timer, check today's hours, log finished work, and see the week. See [Usage](#usage). | Claude Code, Cowork, Cursor |
| **Agents** | A reporter that sums up your hours for a period, and a reviewer that checks your entries for gaps, overlaps, and missing descriptions. | Claude Code, Cowork, Cursor |

## Prerequisites

You need a Timesheet account. The connector needs nothing else: you sign in with that account the first time the agent uses it.

The skill also works without the connector, through the Timesheet CLI. For that, install the CLI globally:

```bash
npm install -g @timesheet/cli
```

Authenticate once via OAuth:

```bash
timesheet auth login
```

For automation, store an API key in the CLI instead:

```bash
timesheet auth apikey --set <your-api-key>
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

### Cursor

1. Clone this repository into Cursor's local plugin folder:

   ```bash
   git clone https://github.com/timesheetIO/timesheet-plugin ~/.cursor/plugins/local/timesheet
   ```

2. Restart Cursor, or run **Developer: Reload Window**.
3. Open **Customize** in the sidebar. Timesheet shows there with its connector, skill, commands, and agents.
4. Sign in with your Timesheet account when the connector asks for it.

Cursor registers itself with Timesheet when it connects, so there is no API key and no client ID to set.

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
| `start [project] [description]` | Starts the timer for a project |
| `stop [description]` | Stops the timer and saves the entry |
| `status` | Shows the timer and today's hours |
| `log [project] [time] [description]` | Adds a finished entry, also for this or the last session |
| `week [last]` | Shows this week's or last week's hours by project |

In Claude Code and Cowork, the commands carry the plugin's name, such as `/timesheet:start Website redesign`. In Cursor, type `/` in the chat and pick the command from the list.

### Agents

- `reporter` builds a report for a period, with hours by project, billable time, and an optional export.
- `reviewer` checks the entries of a period for gaps, overlaps, missing descriptions, very long entries, and unbilled work. It reports what to fix and changes nothing.

Ask for them in your own words, such as "review my timesheet for last week". In Claude Code you can also name one with `@agent-timesheet:reviewer`.

### The skill as a slash command

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

The table lists the CLI's commands by area. The connector's tools cover the same areas, except sign-in and the CLI's own settings.

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
| **Reports** | summary, export, types, templates (list/show/create/update/delete/run) |
| **Profile** | show, update, settings, settings-update |
| **Config** | show, set, reset |

## Configuration

The plugin needs no configuration of its own: no API key, no client ID, and no settings file.

- **Connector:** it signs in through the Timesheet sign-in page in your browser (OAuth 2.1 with PKCE). Your agent registers itself with Timesheet, and the plugin holds no key and no secret.
- **CLI:** it keeps its sign-in in `~/.timesheet-cli/`, so every agent uses the account you signed in with `timesheet auth login` or the key you stored with `timesheet auth apikey --set`.

## Your data

The agent works as the Timesheet user who signed in. It reads and changes only the data that account can access.

The plugin holds no program code: it is Markdown and JSON files and two PNG images. The connector sends the agent's requests to the Timesheet MCP server at `https://mcp.timesheet.io`, which Timesheet runs itself.

- [Privacy policy](https://timesheet.io/en/privacy)
- [Terms of service](https://timesheet.io/en/terms)

## Plugin structure

```
timesheet-plugin/
├── .claude-plugin/
│   ├── marketplace.json  # Claude Code marketplace catalog (one plugin, source ".")
│   └── plugin.json       # Claude Code plugin manifest
├── .codex-plugin/
│   └── plugin.json       # ChatGPT and Codex plugin manifest
├── .cursor-plugin/
│   └── plugin.json       # Cursor plugin manifest
├── .mcp.json             # Timesheet connector for Claude Code, ChatGPT, and Codex
├── mcp.json              # Timesheet connector for Cursor (the same server)
├── agents/               # reporter and reviewer
├── commands/             # start, stop, status, log, week
├── skills/
│   └── timesheet/
│       └── SKILL.md      # YAML frontmatter + command reference
└── README.md
```

## Support

- [Troubleshooting](https://docs.timesheet.io/troubleshooting/)
- Email: support@timesheet.io

## Links

- [timesheet.io](https://timesheet.io)
- [Timesheet MCP server docs](https://docs.timesheet.io/integrations/mcp-server/)
- [@timesheet/cli on npm](https://www.npmjs.com/package/@timesheet/cli)
- [Cursor plugins docs](https://cursor.com/docs/plugins)
- [Claude Code skills docs](https://docs.claude.com/en/docs/claude-code/skills)
- [Claude Code plugin marketplaces](https://docs.claude.com/en/docs/claude-code/plugin-marketplaces)
- [Clawdbot skills docs](https://docs.clawd.bot/tools/skills)

## License

MIT, see [LICENSE.md](LICENSE.md).
