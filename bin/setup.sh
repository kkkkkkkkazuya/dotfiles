#!/bin/zsh

# set directory
current_dir=$(pwd)

# Homebrewのインストール確認
if ! command -v brew &> /dev/null; then
  echo "Homebrewが見つかりません。インストールを開始します。"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# 配備
dotfiles_dir=~/dotfiles

for file in zsh/.zshrc .exports .aliases .functions; do
  ln -sf "$dotfiles_dir/$file" "$HOME/$file"
done

# Check for Homebrew and run brew bundle if Brewfile exists
if type brew &>/dev/null; then
  if [ -f "$current_dir/brew/Brewfile" ]; then
    echo "Found Brewfile. Installing brew packages..."
    brew bundle --file="$current_dir/brew/Brewfile"
  fi
else
  echo "Homebrew not found. Please install Homebrew first."
fi

# シンボリックリンクの作成スクリプトを実行
bash $HOME/dotfiles/link.sh
