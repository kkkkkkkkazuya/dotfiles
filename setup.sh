#!/bin/bash

# Homebrewのインストール確認
if ! command -v brew &> /dev/null; then
  echo "Homebrewが見つかりません。インストールを開始します。"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 必要なパッケージのインストール
brew install git zsh vim tmux

# シンボリックリンクの作成スクリプトを実行
bash $HOME/dotfiles/link.sh
