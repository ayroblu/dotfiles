# Plugins may add significant perf cost to typing
# Press ctrl-k to disable all plugins

zplug 'zsh-users/zsh-completions'
fpath=($ZPLUG_DIR/zsh-completions/src $fpath)

# rm -f ~/.zcompdump; compinit # you might need this to clear cache

# fzf-tab must come before autosuggestions and fsh
zplug 'Aloxaf/fzf-tab'
# Match fzf height, necessary for showing normal height previews
export FZF_TMUX_HEIGHT='60%'
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# switch group using `,` and `.` -- useful for zs<tab>
zstyle ':fzf-tab:*' switch-group ',' '.'
# Default colour is white, doesn't work on light colour schemes
zstyle ':fzf-tab:*' default-color $fg[default]
# Default is tab is down? See PR #22. Reverts to default
zstyle ':fzf-tab:complete:*' fzf-bindings 'tab:toggle+down'
# https://github.com/Aloxaf/fzf-tab/wiki/Preview
# systemctl e.g. systemctl restart
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
# env vars
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'echo ${(P)word}'
# preview files, breaks on other stuff
zstyle ':fzf-tab:complete:*:*' fzf-preview 'preview-unknown "${(Q)realpath}" $group $desc'

zplug 'zsh-users/zsh-autosuggestions'
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=14'

zplug 'zsh-users/zsh-syntax-highlighting'
disable-zsh-syntax-highlighting() {
  ZSH_HIGHLIGHT_MAXLENGTH=0
  region_highlight=()
}

disable-zsh-plugins() {
  disable-fzf-tab
  disable-zsh-syntax-highlighting
  _zsh_autosuggest_disable
}
zle -N disable-zsh-plugins
bindkey '^K' disable-zsh-plugins

