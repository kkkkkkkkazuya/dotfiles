#!/bin/zsh

# set directory
current_dir=$(pwd)

# Homebrewのインストール確認
if ! command -v brew &> /dev/null; then
  echo "Homebrewが見つかりません。インストールを開始します。"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile
if type brew &>/dev/null; then
  if [ -f "$current_dir/brew/Brewfile" ]; then
    echo "Found Brewfile. Installing brew packages..."
    brew bundle --file="$current_dir/brew/Brewfile"
  fi
else
  echo "Homebrew not found. Please install Homebrew first."
fi

# Deploy zsh configuration files to home directory
echo "Deploying zsh configuration files..."
dotfiles_dir="$current_dir"

# Deploy zsh files from zsh/ directory
for file in "$dotfiles_dir/zsh/".*; do
  if [[ -f "$file" && ! "$file" =~ /\.$ && ! "$file" =~ /\.\.$  ]]; then
    filename=$(basename "$file")
    echo "Linking $filename to $HOME/$filename"
    ln -sf "$file" "$HOME/$filename"
  fi
done

# Deploy root dotfiles (.exports, .aliases, .functions)
for file in .exports .aliases .functions; do
  if [[ -f "$dotfiles_dir/$file" ]]; then
    echo "Linking $file to $HOME/$file"
    ln -sf "$dotfiles_dir/$file" "$HOME/$file"
  fi
done

# シンボリックリンクの作成スクリプトを実行
if [[ -f "$dotfiles_dir/bin/link.sh" ]]; then
  echo "Running additional link script..."
  bash "$dotfiles_dir/bin/link.sh"
fi
