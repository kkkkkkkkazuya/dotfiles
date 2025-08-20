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

# VSCode設定ファイルのリンク作成
echo "Deploying VSCode configuration files..."
vscode_user_dir="$HOME/Library/Application Support/Code/User"
mkdir -p "$vscode_user_dir"

for vscode_file in settings.json keybindings.json; do
  if [[ -f "$dotfiles_dir/vscode/$vscode_file" ]]; then
    echo "Linking vscode/$vscode_file to $vscode_user_dir/$vscode_file"
    ln -sf "$dotfiles_dir/vscode/$vscode_file" "$vscode_user_dir/$vscode_file"
  fi
done

# vim設定ファイルのリンク作成
# if [[ -f "$dotfiles_dir/vim/.vimrc" ]]; then
#   echo "Linking vim/.vimrc to $HOME/.vimrc"
#   ln -sf "$dotfiles_dir/vim/.vimrc" "$HOME/.vimrc"
# fi
