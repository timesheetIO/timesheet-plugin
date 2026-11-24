---
name: start
description: Start the Timesheet timer for a project
argument-hint: "[project] [what you're working on]"
disable-model-invocation: true
---

Start the Timesheet timer. Arguments: $ARGUMENTS

1. If the arguments name no project, ask which one. `project_list` with `status` set to `active` returns the projects to choose from, without showing anything.
2. Call `timer_start` with the project named in the arguments as `project`. If the arguments also say what the user is working on, pass it as `description` in the same call. Don't call `timer_status` or `project_list` first.
3. If the result says a timer is already running, say for which project and since when, and ask whether to stop it first. Don't start a second one.
4. If the result says several projects match, list them and ask which one. Then call `timer_start` again with that project's `projectId`.
5. Confirm in one line: the project, the start time, and the description.

Use the Timesheet connector's tools. Without them, use the `timesheet` CLI as the timesheet skill describes.
