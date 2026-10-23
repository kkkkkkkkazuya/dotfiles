# ランタイムと開発ツールの管理

## どこで管理するか

- **版をプロジェクトや CI と揃える必要があるもの → mise**（`mise/config.toml`）
  - 言語のランタイム（node・bun・python・go・rust・java）、パッケージマネージャー（uv・yarn）
  - CI やマイグレーションと版を揃える開発ツール（terraform・tflint・actionlint・trivy・gomigrate）
  - global の CLI（`npm:ccusage`・`npm:@openai/codex`・`npm:@google/gemini-cli`、`go:` の Go のツール）
- **最新ならよいもの → Homebrew**（`brew/Brewfile`）
  - OS の道具（git・gh・awscli・cloudflared・jq・ripgrep・neovim・direnv など）、サービス（postgresql・mysql・docker）、ライブラリ、cask
- 迷ったら「`.xxx-version` や CI で版を指定しているか」で決める。している → mise、していない → Homebrew。
- Claude Code はネイティブ版（`~/.local/bin/claude`）。npm や Brewfile では入れない。

## 書き方

- `mise/config.toml` の版は**必ず固定する**（`latest` や `"24"` を書かない）。2 台の PC で同じ版にするため。safe-chain が mise 経由の npm には効かない可能性があるため。
- npm・go の CLI を `npm -g`・`go install`・`bun add -g` で global に入れない。`mise/config.toml` に足す。
- プロジェクトの版は、そのリポジトリの `.node-version`・`.python-version`・`.terraform-version` に書く（mise はこれらを読む）。`mise.toml` は置かない（nodenv の PC や Cloudflare の Workers Builds が読まない）。
- `idiomatic_version_file_enable_tools` に `go` を入れない。入れると `go.mod` の `go` ディレクティブを読んで古い Go を選ぶ。
- シェルは `mise activate zsh --shims` で有効にする（`--shims` を外さない）。外すと、Claude Code の Bash や MCP のような非対話の実行でフォルダごとの版が効かない。
- `zsh/.zshrc` に、版のフォルダを PATH に直接足す行（`$(npm config get prefix)/bin` など）を書かない。shims より前に来て `.node-version` を無効にする。

## 版を上げるとき

1. `mise/config.toml` の版を書き換える（Node などのセキュリティリリースは、ここと各リポジトリの `.node-version` の 1 行ずつ）
2. `mise install` → 使っているもの（ターミナル・Claude Code・常駐プロセス）を起動し直す
3. `mise prune` で使わなくなった版を消す
