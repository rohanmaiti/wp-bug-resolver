#!/bin/bash
# PreToolUse hook: blocks Jira writes (comment, transition, edit, create)
# while a /resolve-batch run is active (lock file present).
LOCK="${CLAUDE_PROJECT_DIR:-.}/knowledge/batch-runs/.batch-active"
if [ -f "$LOCK" ]; then
  echo "Blocked: a /resolve-batch run is active. Jira is never written to in batch mode; print the comment in chat instead. If no batch is running, delete knowledge/batch-runs/.batch-active." >&2
  exit 2
fi
exit 0
