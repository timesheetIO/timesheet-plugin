#!/bin/sh
# SessionStart hook of the Timesheet plugin. It records when the session
# started, so Claude can log the session's time on request, and reminds the
# user once when the last session in the same folder ran 15 minutes or more
# without any time logged. Claude Code shows nothing a SessionEnd hook prints,
# so the reminder waits for the next start.

case "$CLAUDE_PLUGIN_OPTION_SESSION_REMINDERS" in
  false | FALSE | False | 0 | no | No | NO | off | Off | OFF) exit 0 ;;
esac
[ -n "$CLAUDE_PLUGIN_DATA" ] || exit 0

input=$(cat)
# First string value of a key in the hook input.
field() {
  printf '%s' "$input" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -n 1 | sed 's/.*"\([^"]*\)"$/\1/'
}
session=$(field session_id | tr -cd 'A-Za-z0-9_-')
source=$(field source)
cwd=$(field cwd)
[ -n "$session" ] || exit 0

dir="$CLAUDE_PLUGIN_DATA/sessions"
mkdir -p "$dir" || exit 0
file="$dir/$session"

# ISO 8601 with a colon in the UTC offset, such as 2026-09-27T09:10:00+02:00.
iso_now() {
  date +%Y-%m-%dT%H:%M:%S%z | sed 's/\([+-][0-9][0-9]\)\([0-9][0-9]\)$/\1:\2/'
}
# First value of a key in a session file, or the last one with "last".
value() {
  if [ "$3" = last ]; then
    sed -n "s/^$2=//p" "$1" | tail -n 1
  else
    sed -n "s/^$2=//p" "$1" | head -n 1
  fi
}
duration() {
  h=$(($1 / 3600))
  m=$((($1 % 3600) / 60))
  if [ "$h" -gt 0 ]; then echo "$h h $m min"; else echo "$m min"; fi
}

if [ ! -f "$file" ]; then
  printf 'start=%s\nstart_iso=%s\ncwd=%s\n' "$(date +%s)" "$(iso_now)" "$cwd" > "$file" || exit 0
fi
started=$(value "$file" start_iso)
context="Timesheet: this Claude Code session started at $started. If the user asks to log the time of this session, use that as the start and the current time as the end."
message=""

if [ "$source" != compact ]; then
  # Forget sessions older than two weeks.
  find "$dir" -type f -mtime +14 -exec rm -f {} + 2>/dev/null
  latest=""
  latest_end=0
  count=0
  for f in "$dir"/*; do
    [ -f "$f" ] && [ "$f" != "$file" ] || continue
    grep -q -x -e 'logged=1' -e 'reminded=1' "$f" && continue
    [ "$(value "$f" cwd)" = "$cwd" ] || continue
    s=$(value "$f" start)
    e=$(value "$f" end last)
    case "$s" in '' | *[!0-9]*) continue ;; esac
    case "$e" in '' | *[!0-9]*) continue ;; esac
    [ $((e - s)) -ge 900 ] || continue
    echo 'reminded=1' >> "$f"
    count=$((count + 1))
    if [ "$e" -gt "$latest_end" ]; then
      latest="$f"
      latest_end=$e
    fi
  done
  if [ -n "$latest" ]; then
    from=$(value "$latest" start_iso)
    to=$(value "$latest" end_iso last)
    took=$(duration $((latest_end - $(value "$latest" start))))
    day=$(printf '%s' "$from" | cut -c1-10)
    from_time=$(printf '%s' "$from" | cut -c12-16)
    to_time=$(printf '%s' "$to" | cut -c12-16)
    message="Timesheet: your last session in this folder ran $took on $day, from $from_time to $to_time, and no time was logged. Run /timesheet:log last session to add it."
    if [ "$count" -eq 2 ]; then
      message="$message One earlier session here wasn't logged either."
    elif [ "$count" -gt 2 ]; then
      message="$message $((count - 1)) earlier sessions here weren't logged either."
    fi
    context="$context The last session in this folder ran from $from to $to and no time was logged for it. If the user asks to log the last session, use these times."
  fi
fi

if [ -n "$message" ]; then
  printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$message" "$context"
else
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$context"
fi
exit 0
