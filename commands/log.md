---
description: Add a finished time entry to Timesheet
argument-hint: "[project] [date or time range] [what you did]"
disable-model-invocation: true
---

Add a time entry for work that is already done. Arguments: $ARGUMENTS

1. Read the project, the date, the start and end time or a duration, and the description from the arguments, such as "Acme 9:00-12:30 workshop" or "2h yesterday on Website redesign".
2. If the arguments ask for this session or the last session, use the times that the Timesheet session hook added to this conversation. For this session, end the entry now.
3. Find the project with `project_list` and `search`. If the arguments name no project, or several projects match, ask which one.
4. If there is a duration but no start time, ask for the start, or end the entry now when the request says so.
5. Call `task_create` with `projectId`, `startDateTime`, `endDateTime`, and `description`. Write times in ISO 8601 with the user's UTC offset, such as `2026-09-24T09:00:00+02:00`.
6. Confirm in one line: the project, the date, the times, the duration, and the description.

Ask before creating the entry when the project, the date, or the times are unclear. Use the Timesheet connector's tools. Without them, use the `timesheet` CLI as the timesheet skill describes.
