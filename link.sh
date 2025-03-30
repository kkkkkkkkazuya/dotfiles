#!/bin/bash

# 管理対象のファイルとそのリンク先を定義
files_and_paths=(
  "zshrc:$HOME/.zshrc"
  "vimrc:$HOME/.vimrc"
  "gitconfig:$HOME/.gitconfig"
)

# シンボリックリンクを作成する関数
create_symlink() {
  local source_file="$HOME/dotfiles/$1"
  local target_file="$2"

  # 既存のファイルがある場合はバックアップ
  if [ -e "$target_file" ]; then
    mv "$target_file" "${target_file}.bak"
  fi

  # シンボリックリンクの作成
  ln -s "$source_file" "$target_file"
}

# 定義したファイルごとにシンボリックリンクを作成
for file_and_path in "${files_and_paths[@]}"; do
  IFS=":" read -r file target <<< "$file_and_path"
  create_symlink "$file" "$target"
done
