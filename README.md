# dotfiles

個人用の開発環境設定ファイル集。macOS環境での開発環境の自動セットアップに対応。

## PC移行時のセットアップ手順

### 1. リポジトリのクローン
```bash
cd ~
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
```

### 2. 自動セットアップの実行
```bash
./bin/setup.sh
```

このスクリプトは以下を実行します：
- Homebrewのインストール（未インストールの場合）
- `brew/Brewfile`からすべてのパッケージをインストール
  - CLI tools（git, docker, postgresql等）
  - GUI applications（aws-vault等）
  - VS Code extensions
- `mise/config.toml`を`~/.config/mise/config.toml`にリンクし、`mise install`でランタイムと開発ツールを入れる
- Claude Code（ネイティブ版）のインストール（未インストールの場合）
- `zsh/`配下の設定ファイルを`~`にシンボリックリンク作成（.zshrc, .zprofile）
- その他の設定ファイル（.exports, .aliases, .functions）をリンク
- VS Code設定ファイル（settings.json, keybindings.json）をリンク
- vim設定ファイル（.vimrc）をリンク

### 3. シークレット情報の設定
```bash
# 環境変数ファイルを作成（リポジトリには含まれません）
touch ~/.secrets.sh
# 必要なAPIキーや認証情報を記載
echo 'export API_KEY="your-api-key"' >> ~/.secrets.sh
```

### 4. シェルの再起動
```bash
exec zsh -l
```

## 環境変数の管理

### secrets.shの使用方法
プライベートな環境変数は`~/.secrets.sh`に記載します（リポジトリ管理外）：

```bash
# ~/.secrets.sh の例
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export OPENAI_API_KEY="your-api-key"
```

このファイルは`.zshrc`から自動で読み込まれます。

## 開発ツール設定

### mise（ランタイムと開発ツールの管理）
- Node・Bun・Python・Go・Rust・Java・uv・yarn・Terraform・tflint などと、global の CLI（ccusage・codex・gemini、Go のツール）を `mise/config.toml` で版を固定して管理する
- どれを mise に入れ、どれを Homebrew に残すかの方針は `.claude/CLAUDE.md`
- 版を上げる: `mise/config.toml` の版を書き換え → `mise install` → 使っているものを起動し直す → `mise prune`

### PostgreSQL
- PostgreSQL 16がインストール・設定済み
- パスが自動で設定されます

## 手動でのパッケージ管理

### パッケージの追加
```bash
cd brew
# 新しいパッケージをインストール
brew install package-name
# Brewfileを更新
brew bundle dump --describe --force --file=./Brewfile
```

## トラブルシューティング

### 環境変数が読み込まれない場合
1. シェルがzshか確認：`echo $SHELL`
2. .zshrcを手動読み込み：`source ~/.zshrc`
3. secrets.shを直接読み込み：`source ~/.secrets.sh`

### VS Code設定が反映されない場合
VS Code設定ファイルは以下に配置されます：
- macOS: `~/Library/Application Support/Code/User/`

## Claude Code設定

### Claude専用セットアップ
Claude Code の設定を別途管理する場合：

```bash
./bin/claude_setup.sh
```

このスクリプトは以下のClaude設定を`~/.claude`にリンクします：
- `claude_desktop_config.json` - Claude Desktop設定
- `CLAUDE.md` - プロジェクト固有の指示
- `settings.json` - Claude Code設定
- `commands/` - カスタムコマンド
- `hooks/` - フック設定

### Claude設定の管理
- `.claude/` ディレクトリ内のファイルを編集して設定をカスタマイズ
- 設定変更後は `./bin/claude_setup.sh` を再実行
- 既存設定は自動的に `.bak` ファイルとしてバックアップ

## FYI
claude hooks: https://zenn.dev/gki/articles/1ee8d78a10ede2
