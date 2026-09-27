---
description: Stop the running Timesheet timer and save the entry
argument-hint: "[what you did]"
disable-model-invocation: true
---

Stop the Timesheet timer. Arguments: $ARGUMENTS

1. Call `timer_status`. If no timer is running, say so and stop here.
2. Work out the description. Use the arguments if there are any. Otherwise, if this conversation shows work done while the timer ran, write a one-line summary of it. If there is neither, keep the timer's current description.
3. If the description changed, save it with `timer_update` and `description`.
4. Call `timer_stop`.
5. Confirm in one line: the project, the duration, and the description.

Use the Timesheet connector's tools. Without them, use the `timesheet` CLI as the timesheet skill describes.
