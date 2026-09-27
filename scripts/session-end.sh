#!/bin/sh
# SessionEnd hook of the Timesheet plugin. It records when the session ended,
# so the next session start can tell how long it ran.

[ -n "$CLAUDE_PLUGIN_DATA" ] || exit 0
input=$(cat)
session=$(printf '%s' "$input" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | head -n 1 | sed 's/.*"\([^"]*\)"$/\1/' | tr -cd 'A-Za-z0-9_-')
[ -n "$session" ] || exit 0
file="$CLAUDE_PLUGIN_DATA/sessions/$session"
[ -f "$file" ] || exit 0
end_iso=$(date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/')
printf 'end=%s\nend_iso=%s\n' "$(date +%s)" "$end_iso" >> "$file"
exit 0
