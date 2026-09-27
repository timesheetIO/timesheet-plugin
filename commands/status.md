---
description: Show the Timesheet timer and today's hours
disable-model-invocation: true
---

Show where the user stands in Timesheet today.

1. Call `timer_status`. If a timer is running, note the project, the start time, and the time so far.
2. Call `statistics_get` with today's date as `startDate` and `endDate`, for today's total and the hours by project.
3. Answer in two or three short lines: the timer, today's total, and the projects worked on today. Write durations in hours and minutes, such as 3 h 20 min.

Use the Timesheet connector's tools. Without them, use the `timesheet` CLI as the timesheet skill describes.
