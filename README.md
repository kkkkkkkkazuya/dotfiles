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
- `zsh/`配下の設定ファイルを`~`にシンボリックリンク作成
- その他の設定ファイル（.exports, .aliases, .functions）をリンク
- 追加のリンク設定（bin/link.sh）を実行

### 3. シークレット情報の設定
```bash
# 環境変数ファイルを作成（リポジトリには含まれません）
touch ~/.secrets.sh
# 必要なAPIキーや認証情報を記載
```

### 4. シェルの再起動
```bash
exec zsh -l
```

## 手動でのパッケージ管理

### パッケージの追加
```bash
cd brew
# 新しいパッケージをインストール
brew install package-name
# Brewfileを更新
brew bundle dump --describe --force --file=./Brewfile
```

### 個別のリンク作成
```bash
./bin/link.sh
```

## zsh関連

### zprofile書き換え
```
# ログインシェルを明示的に再起動
exec zsh -l
```
