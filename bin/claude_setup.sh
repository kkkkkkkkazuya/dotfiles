#!/bin/zsh

# Claude Code 設定ファイルのセットアップスクリプト
# Claude Code の設定を適切な場所にリンクします

echo "Claude Code configuration setup starting..."

# 現在のディレクトリを取得
current_dir=$(pwd)
dotfiles_dir="$current_dir"
claude_config_dir="$HOME/.claude"
claude_desktop_dir="$HOME/Library/Application Support/Claude"

# ディレクトリを作成
echo "Creating configuration directories..."
mkdir -p "$claude_config_dir"
mkdir -p "$claude_desktop_dir"

# Claude Code設定ファイルのリンク作成（~/.claude/）
echo "Deploying Claude Code configuration files to ~/.claude/..."

# ~/.claude/ に配置する設定ファイル
claude_code_files=(
    "claude/global/CLAUDE.md"
    "claude/global/settings.json"
)

# ファイルごとにシンボリックリンクを作成
for source_path in "${claude_code_files[@]}"; do
    source_file="$dotfiles_dir/$source_path"
    target_name=$(basename "$source_path")
    target_file="$claude_config_dir/$target_name"
    
    if [[ -f "$source_file" ]]; then
        echo "Linking $source_path to ~/.claude/$target_name"
        ln -sf "$source_file" "$target_file"
    else
        echo "Warning: $source_file does not exist, skipping..."
    fi
done

# Claude Desktop設定ファイルのリンク作成（~/Library/Application Support/Claude/）
echo "Deploying Claude Desktop configuration..."

claude_desktop_source="$dotfiles_dir/claude/global/claude_desktop_config.json"
claude_desktop_target="$claude_desktop_dir/claude_desktop_config.json"

if [[ -f "$claude_desktop_source" ]]; then
    echo "Linking claude/global/claude_desktop_config.json to ~/Library/Application Support/Claude/"
    ln -sf "$claude_desktop_source" "$claude_desktop_target"
else
    echo "Warning: $claude_desktop_source does not exist, skipping..."
fi

# 既存の .claude/ ディレクトリ構造もサポート（後方互換性）
if [[ -d "$dotfiles_dir/.claude" ]]; then
    echo "Found legacy .claude/ directory, linking additional files..."
    
    # レガシーディレクトリ（commands, hooks）のリンク作成
    for dir in commands hooks; do
        source_dir="$dotfiles_dir/.claude/$dir"
        target_dir="$claude_config_dir/$dir"
        
        if [[ -d "$source_dir" ]]; then
            echo "Linking .claude/$dir to ~/.claude/$dir"
            ln -sf "$source_dir" "$target_dir"
        fi
    done
fi

echo ""
echo "✅ Claude configuration setup completed!"
echo ""
echo "Claude Code settings (~/.claude/):"
ls -la "$claude_config_dir" 2>/dev/null || echo "No files in ~/.claude/"
echo ""
echo "Claude Desktop settings (~/Library/Application Support/Claude/):"
ls -la "$claude_desktop_dir" 2>/dev/null || echo "No files in Claude Desktop directory"
echo ""
echo "Claude will now use your custom configuration from this dotfiles repository."