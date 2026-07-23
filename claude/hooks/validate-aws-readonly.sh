#!/bin/bash
# aws-investigator サブエージェント用 PreToolUse フック
# Bash ツールで実行される aws コマンドを検査し、変更系操作（create/delete/update等）をブロックする
# 参考: https://code.claude.com/docs/en/sub-agents (Conditional rules with hooks)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

# 変更系サブコマンド（create-*, delete-*, update-* など）をブロック
if echo "$COMMAND" | grep -qE 'aws[[:space:]]+([^[:space:]]+[[:space:]]+)*\b(create|delete|update|put|modify|terminate|attach|detach|start|stop|reboot|associate|disassociate|register|deregister|enable|disable|tag|untag|revoke|authorize|cancel|reset|release|replace|restore|import|remove|add|set)-'; then
  echo "Blocked: 変更系の aws コマンドは実行できません（このエージェントは読み取り専用です）" >&2
  exit 2
fi

# s3 の高レベル変更コマンド（cp/mv/rm/sync/mb/rb）をブロック
if echo "$COMMAND" | grep -qE 'aws[[:space:]]+s3[[:space:]]+(cp|mv|rm|sync|mb|rb)\b'; then
  echo "Blocked: s3 の変更系コマンドは実行できません（このエージェントは読み取り専用です）" >&2
  exit 2
fi

exit 0
