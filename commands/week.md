---
description: Show this week's hours in Timesheet by project
argument-hint: "[last]"
disable-model-invocation: true
---

Sum up the user's hours for a week. Arguments: $ARGUMENTS

1. Use the current week, or the previous week when the arguments say "last". The week starts on the first day of the week from `settings_get`, or on Monday when it has none.
2. Call `statistics_get` with the first and last day of the week as `startDate` and `endDate`.
3. Show the total with its billable part, a short table of hours by project, and the hours per day. Write durations in hours and minutes, such as 7 h 45 min.
4. End with one line on anything that stands out, such as a workday with no entries.

Use the Timesheet connector's tools. Without them, use `timesheet reports summary` as the timesheet skill describes.
