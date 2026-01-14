###################################################
# 1. Powerlevel10k インスタントプロンプト
#    （起動時に即座にプロンプト表示）
###################################################
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###################################################
# 2. zinit初期化 + プラグイン
# ※ Homebrew初期化は .zprofile で実行
###################################################
# zinit本体の読み込み
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Powerlevel10k テーマ
zinit ice depth=1
zinit light romkatv/powerlevel10k

# 補完強化
zinit light zsh-users/zsh-completions

# 入力中に過去のコマンドをグレー表示
zinit light zsh-users/zsh-autosuggestions

# コマンドのシンタックスハイライト（存在しないコマンドは赤）
zinit light zsh-users/zsh-syntax-highlighting

# OMZのgitプラグイン（gst, gco等のエイリアス）
zinit snippet OMZ::plugins/git/git.plugin.zsh

###################################################
# 3. 環境変数・PATH設定
###################################################
# 基本設定
export LANG=ja_JP.UTF-8
export EDITOR=vim

# anyenv
typeset -a ANYENV_TARGETS
ANYENV_TARGETS=(pyenv goenv nodenv tfenv)

if [[ -d $HOME/.anyenv ]]; then
  export ANYENV_ROOT="$HOME/.anyenv"
  export PATH="$ANYENV_ROOT/bin:$PATH"
  eval "$(anyenv init - zsh)"

  # 未インストールの env を自動導入
  for _env in $ANYENV_TARGETS; do
    [[ -d "$ANYENV_ROOT/envs/${_env}" ]] || anyenv install -s "${_env}"
  done
fi

# PostgreSQL
export PATH="/usr/local/opt/postgresql@16/bin:$PATH"

# npm
export PATH="$(npm config get prefix)/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# n8n
export N8N_COMMUNITY_NODES_ENABLED=true

# cloudflare
export CF_ACCOUNT_ID="30ca88c92eb1a8acb8ff8520779ea8ae"
export CLOUDFLARE_API_TOKEN="R0o30ErzfztZid5xnKU9tOmhqxTmnnVmQdm41UF1"

###################################################
# 4. シークレット読み込み
###################################################
if [[ -f ~/.secrets.sh ]]; then
    source ~/.secrets.sh
fi

###################################################
# 5. モジュラー設定読み込み
###################################################
for file in ~/.{exports,aliases,functions}; do
  [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

###################################################
# 6. direnv フック
###################################################
eval "$(direnv hook zsh)"

###################################################
# 7. シェルオプション（setopt）
###################################################
# history
HISTFILE=$HOME/.zsh_history     # 履歴を保存するファイル
HISTSIZE=100000                 # メモリ上に保存する履歴のサイズ
SAVEHIST=1000000                # 上述のファイルに保存する履歴のサイズ

setopt inc_append_history       # 実行時に履歴をファイルにに追加していく
setopt share_history            # 履歴を他のシェルとリアルタイム共有する
setopt auto_param_slash         # ディレクトリ名の補完で末尾の / を自動的に付加
setopt auto_param_keys          # カッコを自動補完
setopt mark_dirs                # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt auto_menu                # 補完キー連打で順に補完候補を自動で補完
setopt correct                  # スペルミス訂正
setopt interactive_comments     # コマンドラインでも # 以降をコメントと見なす
setopt magic_equal_subst        # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word         # 語の途中でもカーソル位置で補完
setopt print_eight_bit          # 日本語ファイル名を表示可能にする
setopt auto_cd                  # ディレクトリ名だけでcdする

###################################################
# 8. 補完設定（zstyle）
###################################################
autoload -Uz compinit && compinit
autoload -Uz colors && colors

# Tabで選択できるように
zstyle ':completion:*:default' menu select=2

# 補完候補をそのまま→小文字を大文字→大文字を小文字に変更
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

# 補完方法毎にグループ化する
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''

# ファイル補完候補に色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

###################################################
# 9. カスタム関数・エイリアス
###################################################
# bun completions
[ -s "/Users/kojimakazuya/.bun/_bun" ] && source "/Users/kojimakazuya/.bun/_bun"

# kiro
# [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# peco: 過去に実行したコマンドを選択
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | awk '!a[$0]++' | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history

# peco: 過去に移動したことのあるディレクトリを選択
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr

# ブランチを簡単切り替え。git checkout lbで実行できる
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

# dockerコンテナに入る。deで実行できる
alias de='docker exec -it $(docker ps | peco | cut -d " " -f 1) /bin/bash'

###################################################
# 10. カスタムキーバインド（最後に設定）
###################################################
bindkey '^r' peco-select-history  # ctrl-r: 履歴検索
bindkey '^u' peco-cdr             # ctrl-u: ディレクトリ移動

###################################################
# 11. Powerlevel10k 設定読み込み
###################################################
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
