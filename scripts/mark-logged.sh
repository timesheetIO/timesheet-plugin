#!/bin/sh
# PostToolUse hook of the Timesheet plugin. It notes that time was logged in
# this session, with the connector's tools or the timesheet CLI, so the next
# session start doesn't remind the user about this session.

[ -n "$CLAUDE_PLUGIN_DATA" ] || exit 0
input=$(cat)
if [ "$1" = cli ]; then
  printf '%s' "$input" | grep -Eq '"command"[[:space:]]*:[[:space:]]*"[^"]*timesheet[[:space:]]+(tasks[[:space:]]+create|timer[[:space:]]+(start|stop))' || exit 0
fi
session=$(printf '%s' "$input" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed 's/.*"\([^"]*\)"$/\1/' | tr -cd 'A-Za-z0-9_-')
[ -n "$session" ] || exit 0
file="$CLAUDE_PLUGIN_DATA/sessions/$session"
[ -f "$file" ] || exit 0
grep -q -x 'logged=1' "$file" || echo 'logged=1' >> "$file"
exit 0
