plugins=(git)
# History
# Disable Delete Warning
unsetopt RM_STAR_SILENT
# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_dups
setopt hist_ignore_space
setopt appendhistory
setopt sharehistory
setopt inc_append_history

#Tab completion
autoload -Uz compinit
compinit
zstyle ':completion:*'  list-colors '=*=90'
zstyle ':completion:*' menu select 

# Zoxide Init
eval "$(zoxide init zsh)"
# Starship Init
eval "$(starship init zsh)"

# ZSH Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Aliases
unalias -a
alias ls="lsd -F"
alias ll="lsd -lhFA"
alias cls=clear
alias i="sudo pacman -S --noconfirm --needed" 
alias r="sudo pacman -Rsc --noconfirm"
alias s="pacman -Ss"
alias u="sudo pacman -Syu --noconfirm"
alias q="pacman -Qs"
alias cd="z"
alias cat=bat
alias vim=nvim
alias dvim="sudo -E nvim"
alias ga="git add -A"
alias gs="git status"
alias gc='git commit -m '
alias gp="git push"
alias gr="git rm"
alias srv="ssh adosha@hs.lan"
alias timeshift="sudo GTK_THEME=Adwaita:dark ICON_THEME=Adwaita timeshift-gtk"
alias m="unimatrix  -l naAS -s 96"
alias bios="sudo systemctl reboot --firmware-setup"
export FZF_DEFAULT_COMMAND='fd . -t f -t d --exclude={.git,.cache} --hidden'
export FZF_CTRL_T_COMMAND=' fd . -t f --exclude={.git,.cache} --hidden'
export FZF_ALT_C_COMMAND='  fd . -t d --exclude={.git,.cache} --hidden '

# Netwoek
alias moni="sudo ip link set wlp0s20f0u3 down;sudo iw dev wlp0s20f0u3 set type monitor;sudo ip link set wlp0s20f0u3 up;sudo aireplay-ng -9 wlp0s20f0u3"
alias mana="sudo ip link set wlp0s20f0u3 down;sudo iw dev wlp0s20f0u3 set type managed;sudo ip link set wlp0s20f0u3 up"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# File Manager Function
function _yz_helper() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
         yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# ZLE widget wrapper
function yz() {
	zle -I  # clear current input line
	_yz_helper
	zle reset-prompt  # refresh prompt after cd
}

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# FZF Keybindings
setopt ignoreeof # Disable default behavior that closes shell EOF
zle -N yz
bindkey -r '^[c'
bindkey -r '^R'
bindkey -r '^T'
bindkey '^Y' yz 
bindkey '^D' fzf-cd-widget
bindkey '^F' fzf-file-widget
bindkey '^H' fzf-history-widget
bindkey '^ ' forward-word

# Env Variables
export EDITOR=nvim
export WAYLAND_DISPLAY=wayland-1
export PATH=$PATH:$HOME/go/bin:$HOME/.local/share/nvim/mason/bin:$HOME/.local/bin

