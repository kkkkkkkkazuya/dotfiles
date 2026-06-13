
# AGENTS.md

プロジェクト規約は `CLAUDE.md` を参照。

---

## Skills

スキル定義は `.agents/skills/`（`.claude/skills/` へのシンボリックリンク）に置く。

```
.agents/skills/ -> ../.claude/skills/
```

- スキルの追加・編集は **`.claude/skills/` 配下のみ**で行う。`.agents/skills/` を直接編集しない。
- 各スキルは `SKILL.md` を持つ。`SKILL.md` 内でプロジェクト規約を参照する場合は `CLAUDE.md` を指す。

## Rules

- タスクを実行する前に `CLAUDE.md` を読み、プロジェクト規約に従う。
- APIキー・シークレットをファイルに直接書かない。
- ユーザーの確認なしにファイルを削除しない。
