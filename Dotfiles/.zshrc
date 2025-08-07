ZSH_THEME="robbyrussell"
plugins=(git)
source /home/adosha/.oh-my-zsh/oh-my-zsh.sh

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ZSH Plugins
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#808080'
unalias -a
alias ls="lsd -F"
alias ll="lsd -lahFA"
alias cls=clear
alias i="doas pacman -S --noconfirm --needed" 
alias r="doas pacman -Rsc --noconfirm"
alias s="pacman -Ss"
alias u="doas pacman -Syu --noconfirm"
alias q="pacman -Qs"
alias cd="z"
alias cat=bat
alias vim=nvim
alias dvim="doas nvim"
alias ga="git add *"
alias gs="git status"
alias gc='git commit -m '
alias gp="git push"
alias srv="ssh adosha@hs.lan"
alias timeshift="sudo -E timeshift-gtk"
#export TERM=xterm-256color
export FZF_DEFAULT_COMMAND='find . -type f'


# File Manager Function
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
         yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


# vi mode
bindkey -v
export KEYTIMEOUT=1

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

PATH=$PATH:$HOME/go/bin
