# 設定ファイルを一括で読み込み
for file in ~/.{exports,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# direnv のフック（インタラクティブ専用でOK）
eval "$(direnv hook zsh)"
