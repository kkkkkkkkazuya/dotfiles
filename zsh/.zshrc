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
fi
exec $SHELL -l

# Go
# export GOROOT=/usr/local/go
# export GOPATH=$HOME/go
# export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# Java
# export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"

# PostgreSQL
export PATH="/usr/local/opt/postgresql@16/bin:$PATH"
