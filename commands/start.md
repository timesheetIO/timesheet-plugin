---
description: Start the Timesheet timer for a project
argument-hint: "[project] [what you're working on]"
disable-model-invocation: true
---

Start the Timesheet timer. Arguments: $ARGUMENTS

1. Call `timer_status`. If a timer is already running, say for which project and since when, and ask whether to stop it first. Don't start a second one.
2. Find the project: call `project_list` with `search` set to the project named in the arguments and `status` set to `active`. If the arguments name no project, or several projects match, list the candidates and ask which one.
3. Call `timer_start` with the project's ID.
4. If the arguments also say what the user is working on, save it with `timer_update` and `description`.
5. Confirm in one line: the project, the start time, and the description.

Use the Timesheet connector's tools. Without them, use the `timesheet` CLI as the timesheet skill describes.
