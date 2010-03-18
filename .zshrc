# vim:set fdm=marker:

bindkey -e

### fpath ### {{{
fpath=(~/.zsh/functions $fpath)
autoload -U ~/.zsh/functions/*(:t)
# }}}
### compinit ### {{{
autoload -U compinit
compinit -u
# }}}
### promptinit ### {{{
if [ $UID != 0 ]; then
    autoload promptinit
    promptinit
    prompt adam2
    # prompt elite2
fi
# }}}
### color ### {{{
# ${fg[...]} や $reset_color をロード
autoload -U colors; colors
# }}}
### completion ### {{{
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# ignore alphabet case when completion,
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# }}}
### search history ### {{{
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# bindkey "^I" menu-complete
# }}}
### setopt ### {{{

# http://journal.mycom.co.jp/column/zsh/index.html
# http://www.crimson-snow.net/tips/unix/zsh.html

setopt always_last_prompt
setopt auto_cd
setopt auto_menu
setopt auto_name_dirs
setopt auto_param_keys
setopt auto_param_slash
setopt auto_pushd
setopt auto_remove_slash
setopt cdable_vars
setopt complete_in_word
setopt correct
setopt extended_glob
setopt extended_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt interactive_comments
setopt list_packed
setopt list_types
setopt magic_equal_subst
setopt mark_dirs
setopt no_beep
setopt no_clobber
setopt no_hup
setopt no_listbeep
setopt notify
setopt print_eight_bit
setopt prompt_subst
setopt pushd_ignore_dups
setopt rm_star_silent
setopt rm_star_wait
setopt sh_word_split
setopt share_history
setopt no_promptcr
# setopt print_exit_value
# }}}
### alias ### {{{
alias df='df -h'
alias di='diff'
alias diff='diff -u'
alias du='du -h'
alias free='free -m -l -t'
alias j='jobs'
alias jobs='jobs -l'
alias l.='ls -d .*'
alias l='ll'
alias la='ls -A'
alias less='less -r'
alias ll='ls -lh'
alias sc='screen'
alias whi='which'
alias whe='where'
alias go='gopen'
alias g='git'

if [ -x "$(which vim)" ]; then
    alias v='vim'
else
    alias v='vi'
fi

if [ -x "$(which perldocjp)" ]; then
    alias perldoc='perldocjp'
fi

OS="$(uname -o)"
if [ "$OS" = "Cygwin" ]; then
    alias less='less -r'
    alias ls='ls --color=tty --show-control-chars'
else
    alias ls='ls --color=tty'
fi

if [ -x "/usr/local/share/vim/vim72/macros/less.sh" ]; then
    alias vless="/usr/local/share/vim/vim72/macros/less.sh"
elif [ -x "/usr/share/vim/vim72/macros/less.sh" ]; then
    alias vless="/usr/share/vim/vim72/macros/less.sh"
fi
# }}}
### misc ### {{{
# カレントディレクトリが変わると実行される {{{
# via http://d.hatena.ne.jp/hiboma/20061005/1160026514
chpwd () { ll }
# }}}
# abbrev {{{
# via http://homepage1.nifty.com/blankspace/zsh/zsh.html
typeset -A myabbrev
myabbrev=(
    "l@" "| less"
    "g@" "| grep"
    "p@" "| perl"
    "s@" "| sort"
    "u@" "| sort -u"
    "c@" "| xsel --input --clipboard"
    "x@" "| xargs"
    "n@" ">/dev/null 2>/dev/null"
    "e@" "2>&1"
    "h@" "--help 2>&1"
)
my-expand-abbrev() {
    local left prefix
    left=$(echo -nE "$LBUFFER" | sed -e "s/[@_a-zA-Z0-9]*$//")
    prefix=$(echo -nE "$LBUFFER" | sed -e "s/.*[^@_a-zA-Z0-9]\([@_a-zA-Z0-9]*\)$/\1/")
    LBUFFER=$left${myabbrev[$prefix]:-$prefix}" "
}
zle -N my-expand-abbrev
bindkey     " "         my-expand-abbrev
# }}}
# gitのブランチ名を右プロンプトに表示 {{{
# http://d.hatena.ne.jp/mollifier/20090814/p1
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"
# }}}
# 補完時に色んな情報を出す {{{
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*' verbose yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
zstyle ':completion:*:messages' format $fg[yellow]'%d'$reset_color
zstyle ':completion:*:warnings' format $fg[red]'No matches for:'$fg[yellow]' %d'$reset_color
zstyle ':completion:*:descriptions' format $fg[yellow]'completing %B%d%b'$reset_color
zstyle ':completion:*:corrections' format $fg[yellow]'%B%d '$fg[red]'(errors: %e)%b'$reset_color
zstyle ':completion:*:options' description 'yes'
# グループ名に空文字列を指定すると，マッチ対象のタグ名がグループ名に使われる。
# したがって，すべての マッチ種別を別々に表示させたいなら以下のようにする
zstyle ':completion:*' group-name ''
# }}}
# 補完のセパレータを設定する {{{
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*' list-separator '-->'
# }}}
# manの補完をセクション番号別に表示させる {{{
# via http://d.hatena.ne.jp/voidy21/20090902/1251918174
zstyle ':completion:*:manuals' separate-sections true
# }}}
# 起動済みバックグランドプロセスの標準出力を見るワンライナー {{{
# via http://subtech.g.hatena.ne.jp/cho45/20091118/1258554176
function snatch () {
    gdb -p $1 -batch -n -x =( echo -e "p (int)open(\"/proc/$$/fd/1\", 1)\np (int)dup2(\$1, 1)\np (int)dup2(\$1, 2)" )
}
# }}}
# C-sによる画面の停止を無効 {{{
# http://d.hatena.ne.jp/hogem/20090411/1239451878
stty stop undef
# }}}
# surround.vimみたいにクォートで囲む {{{
# http://d.hatena.ne.jp/mollifier/20091220/p1

autoload -U modify-current-argument

# シングルクォート用
_quote-previous-word-in-single() {
    modify-current-argument '${(qq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-single
bindkey '^[g' _quote-previous-word-in-single

# ダブルクォート用
_quote-previous-word-in-double() {
    modify-current-argument '${(qqq)${(Q)ARG}}'
    zle vi-forward-blank-word
}
zle -N _quote-previous-word-in-double
bindkey '^[G' _quote-previous-word-in-double
# }}}
# Gitのリポジトリのトップレベルにcdするコマンド {{{
# http://d.hatena.ne.jp/hitode909/20100211/1265879271
function u()
{
    cd ./$(git rev-parse --show-cdup)
    if [ $# = 1 ]; then
        cd $1
    fi
}
# }}}
# mkcd {{{
function mkcd() {
    [ $# = 1 ] && mkdir "$1" && cd "$1"
}
# }}}
# viwi {{{
function viwi() {
    local p
    [ $# != 0 ] && p=`which $1` && vi "$p"
}
# }}}
# }}}
### cygwin ### {{{
if [ "$OS" = 'Cygwin' ]; then

    function wwhich() {
        if [ $# != 0 ]; then
            cygpath -w -a $(which $1)
        fi
    }
    function wpwd() {
        /usr/bin/cygpath -w -a .
    }
    function screen() {
        local conf="$HOME/.screenrc.cygwin"
        if [ -f "$conf" ]; then
            command screen -c "$conf" "$@"
        else
            command screen "$@"
        fi
    }
fi
# }}}
