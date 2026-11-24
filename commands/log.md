---
name: log
description: Add a finished time entry to Timesheet
argument-hint: "[project] [date or time range] [what you did]"
disable-model-invocation: true
---

Add a time entry for work that is already done. Arguments: $ARGUMENTS

1. Read the project, the date, the start and end time or a duration, and the description from the arguments, such as "Acme 9:00-12:30 workshop" or "2h yesterday on Website redesign".
2. If the arguments ask for this session, end the entry now. Take the start from the conversation when it says when the work began. Otherwise ask for it.
3. If the arguments name no project, ask which one.
4. If there is a duration but no start time, ask for the start, or end the entry now when the request says so.
5. Call `task_create` with the project's name as `project`, and with `startDateTime`, `endDateTime`, and `description`. Don't call `project_list` first. Write times in ISO 8601 with the user's UTC offset, such as `2026-09-24T09:00:00+02:00`.
6. If the result says no project matches or several do, ask which one. Then call `task_create` again with that project's `projectId`.
7. Confirm in one line: the project, the date, the times, the duration, and the description.

Ask before creating the entry when the project, the date, or the times are unclear. Use the Timesheet connector's tools. Without them, use the `timesheet` CLI as the timesheet skill describes.
