# 設定ファイルを一括で読み込み
for file in ~/.{exports,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

# direnv のフック（インタラクティブ専用でOK）
eval "$(direnv hook zsh)"

# Homebrewの初期化（OSによってパスが異なる）
if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "$HOME/.linuxbrew" ]; then
  eval "$($HOME/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export LANG=ja_JP.UTF-8
export EDITOR=vim

# セキュアな環境変数
if [[ -f ~/.secrets.sh ]]; then
    source ~/.secrets.sh
fi

# anyenv
typeset -a ANYENV_TARGETS
# 必要なenvライブラリの追加
ANYENV_TARGETS=(pyenv goenv nodenv tfenv)

if [[ -d $HOME/.anyenv ]]; then
  export ANYENV_ROOT="$HOME/.anyenv"
  export PATH="$ANYENV_ROOT/bin:$PATH"
  eval "$(anyenv init - zsh)"

  # 3. 初回シェル起動時に未インストールの env を自動導入
  for _env in $ANYENV_TARGETS; do
    [[ -d "$ANYENV_ROOT/envs/${_env}" ]] || anyenv install -s "${_env}"
  done
  
  # 初回のみシェルを再起動（環境変数の再読み込みのため）
  if [[ -z "$ANYENV_INITIALIZED" ]]; then
    export ANYENV_INITIALIZED=1
    exec $SHELL -l
  fi
fi

# PostgreSQL
export PATH="/usr/local/opt/postgresql@16/bin:$PATH"

# npm
export PATH="$(npm config get prefix)/bin:$PATH"

#n8n
export N8N_COMMUNITY_NODES_ENABLED=true
