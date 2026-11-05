# ~/.zshrc — managed by ~/dotfiles (stow package: zsh)
# Palette: Cyberpunk Neon — bg #000b1e  text #d7fffe  neon #00ff9f  cyan #00b8ff  pink #ea00d9
#          red #ff2a6d  yellow #f9f002  teal #0abdc6  dim #133e7c  bg2 #0a1428

# --- history / options ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY AUTO_CD
bindkey -e

# --- LS_COLORS (eza + completion): dirs green, executables pink, links cyan ---
export LS_COLORS="di=1;38;2;0;255;159:ex=1;38;2;234;0;217:ln=38;2;0;184;255:or=38;2;255;42;109:mi=38;2;255;42;109:so=38;2;249;240;2:pi=38;2;249;240;2:bd=38;2;10;189;198:cd=38;2;10;189;198:su=38;2;0;11;30;48;2;255;42;109:sg=38;2;0;11;30;48;2;249;240;2:tw=38;2;0;11;30;48;2;0;255;159:ow=1;38;2;0;255;159"

autoload -Uz compinit && compinit
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# --- tools ---
eval "$(zoxide init zsh)"
source <(fzf --zsh)
eval "$(starship init zsh)"

# fzf — bg:-1 keeps kitty's background_opacity (an explicit hex bg renders opaque)
export FZF_DEFAULT_OPTS=" \
--color=fg:#d7fffe,bg:-1,hl:#00ff9f \
--color=fg+:#ffffff,bg+:#0a1428,hl+:#00ff9f \
--color=selected-fg:#ffffff,selected-bg:#133e7c,gutter:-1 \
--color=info:#0abdc6,prompt:#00ff9f,pointer:#ea00d9,marker:#ea00d9 \
--color=spinner:#00b8ff,header:#00b8ff,query:#d7fffe,disabled:#133e7c \
--color=border:#133e7c,separator:#133e7c,scrollbar:#00b8ff,label:#d7fffe \
--color=preview-border:#133e7c,preview-label:#00b8ff"

# bat: "ansi" theme follows kitty's 16-color palette
export BAT_THEME="ansi"

# --- aliases ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --git'
alias cat='bat'
alias cd='z'

# --- plugins (syntax-highlighting must be sourced last) ---
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#133e7c'
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# syntax highlighting: valid = neon green, invalid = red
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff2a6d,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#ea00d9'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[function]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[command]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#00ff9f,italic'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#00ff9f'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#0abdc6'
ZSH_HIGHLIGHT_STYLES[path]='fg=#d7fffe,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#00b8ff'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#00b8ff'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#00b8ff'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#f9f002'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#f9f002'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#f9f002'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#0abdc6'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ea00d9'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ea00d9'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#133e7c'

# --- greeting ---
[[ -o interactive ]] && fastfetch
