# TTY {{{
if [ "$(tty)" = "/dev/tty1" ]; then
	sleep 1 && startx
fi

if tty | grep -q "/dev/tty"; then
	$HOME/.config/scripts/set_tty_colors.sh
fi
# }}}
# Options {{{
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' glob 1
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-/]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
setopt autocd
unsetopt beep notify
bindkey -v
# End of lines configured by zsh-newuser-install
# }}}
# Plugins {{{
source /usr/share/zsh/share/antigen.zsh

# Load the oh-my-zsh's library.
antigen use oh-my-zsh

antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle olivierverdier/zsh-git-prompt
antigen bundle jeffreytse/zsh-vi-mode

antigen apply

# Insulter
. ~/.config/zsh-plugins/bash-insulter/src/bash.command-not-found

# Git prompt
source ~/.config/zsh-plugins/zsh-git-prompt/zshrc.sh

# }}}
# Colors {{{
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]=''
ZSH_HIGHLIGHT_STYLES[command]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
ZSH_HIGHLIGHT_STYLES[hashed-command]=''
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[path]='fg=blue,underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=''
ZSH_HIGHLIGHT_STYLES[path_prefix]=''
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=''
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command-substitution]='none'
ZSH_HIGHLIGHT_STYLES[command-substitution-unquoted]=''
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]=''
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]=''
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]=''
ZSH_HIGHLIGHT_STYLES[process-substitution]='none'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[arithmetic-expansion]=''
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='none'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='none'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]=''
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]=''
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]=''
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]=''
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='none'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#67a'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#67a'
ZSH_HIGHLIGHT_STYLES[named-fd]='none'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='none'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'
ZSH_HIGHLIGHT_STYLES[default]='none'
# }}}
# Environment {{{
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export BROWSER=/usr/bin/firefox
export AUR_PAGER="$HOME/.config/scripts/rangerp.sh"
# }}}
# Aliases {{{
alias update-wallpapers="sudo systemctl restart wallpapers"
alias mount-all="$HOME/scripts/mount-all.sh"
alias unmount-all="$HOME/scripts/unmount-all.sh"
alias umount-all="$HOME/scripts/unmount-all.sh"
alias aur-remove='repo-remove /home/custompkgs/custom.db.tar.gz'

alias vi='vim'
alias vim='nvim' # idk...
alias gvim='vim "+Gclog" "+Gstatus"' # imagine using graphical vim lmao
alias ecfg='nvim +"cd ~/.config" +"Gclog" +"Gstatus"'

alias icat='kitty +kitten icat'

# I'm bad at typing
alias claer='clear'

alias mutt='neomutt'
alias mbsync='mbsync -Vac ~/.config/isync/mbsyncrc && notmuch new'

alias ssh='TERM=xterm ssh'

function gls() {

	# nah, fuck this, idfc, it's not robust

	files=$(ls --color=always \
			| egrep --color=never "($(\
				echo -n $(git ls-tree --name-only HEAD)\
				| sed 's/\./\\./g;s/[[:space:]]\+/|/g'))")

	files_no_color=$(ls --color=never \
			| egrep --color=never "($(\
				echo -n $(git ls-tree --name-only HEAD)\
				| sed 's/[[:space:]]\+/|/g'))")

	# arrange columns based on uncolored variant (or they will not align)
	cols="$(column <(echo "$files_no_color") --fillrows)"

	IFS="
"
	for i in $(paste <(echo "$files") <(echo "$files_no_color")); do
		x="$(echo "$i" | sed 's/\(.*\)\t\(.*\)/\1/')"
		y="$(echo "$i" | sed 's/\(.*\)\t\(.*\)/\2/')"
		# replace occurences in column with colored version
		cols="$(echo $cols | sed "s/\\(\\t\\|^\\)$y\\(\\t\\|$\\)/\\1$x\\2/")"
	done
	echo $cols
}
# }}}
# Prompt {{{
function git_prompt() {
	# Don't print a prompt if we aren't in a git repo
	if ! [ "$GIT_BRANCH" = ":" ]; then
		echo -n "$(git_super_status)"
	fi
}
function vi_prompt() {
	echo -n "%B%F{black}"
	case $ZVM_MODE in
		$ZVM_MODE_NORMAL)
			echo -n "%K{blue} NORMAL "
		;;
		$ZVM_MODE_INSERT)
			echo -n "%K{green} INSERT "
		;;
		$ZVM_MODE_VISUAL)
			echo -n "%K{yellow} VISUAL "
		;;
		$ZVM_MODE_VISUAL_LINE)
			echo -n "%K{yellow} V-LINE "
		;;
	esac
	echo -n "%b%f%k"
}

ZSH_THEME_GIT_PROMPT_PREFIX="G:["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[cyan]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[yellow]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{↓%G%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{↑%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}%{…%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}%{✔%G%}"

PROMPT=$(echo \
	'$(vi_prompt)'                                                            \
	`# Colored exit code `                                                    \
	'%(?.%F{green}%?.%F{red}%?)'                                              \
	`# user@distro `                                                          \
	'%F{cyan}%n%f@%F{blue}$(sed -n '"'"'s/^ID=//p'"'"' /etc/os-release)'      \
	`# folder name`                                                           \
	'%F{magenta}%~'                                                           \
	`# Authorization`                                                         \
	'%f%(!.#.$) ')

RPROMPT='$(git_prompt)'
# }}}
# Vi mode {{{
ZVM_CURSOR_STYLE_ENABLED=false
function zvm_after_lazy_keybindings() {
	# zsh vicmd (normal) mode
	zvm_bindkey vicmd "n" vi-backward-char
	zvm_bindkey vicmd "e" down-line-or-history
	zvm_bindkey vicmd "i" up-line-or-history
	zvm_bindkey vicmd "o" vi-forward-char

	zvm_bindkey vicmd "k" zvm_open_line_below
	zvm_bindkey vicmd "l" vi-forward-word-end
	zvm_bindkey vicmd "h" zvm_enter_insert_mode
	zvm_bindkey vicmd "j" vi-repeat-search

	zvm_bindkey vicmd "E" vi-join

	zvm_bindkey vicmd "K" zvm_open_line_above
	zvm_bindkey vicmd "L" vi-forward-blank-word-end
	zvm_bindkey vicmd "H" zvm_insert_bol
	zvm_bindkey vicmd "J" vi-rev-repeat-search

	# zsh viopp mode
	zvm_bindkey vicmd "hW" select-in-blank-word
	zvm_bindkey vicmd "ha" select-in-shell-word
	zvm_bindkey vicmd "hw" select-in-word
	zvm_bindkey vicmd "e"  down-line
	zvm_bindkey vicmd "i"  up-line

	zvm_bindkey vicmd "h"   zvm_readkeys_handler
	zvm_bindkey vicmd "h^[" zvm_select_surround
	zvm_bindkey vicmd "h "  zvm_select_surround
	zvm_bindkey vicmd "h\"" zvm_select_surround
	zvm_bindkey vicmd "h'"  zvm_select_surround
	zvm_bindkey vicmd "h("  zvm_select_surround
	zvm_bindkey vicmd "h)"  zvm_select_surround
	zvm_bindkey vicmd "h<"  zvm_select_surround
	zvm_bindkey vicmd "h>"  zvm_select_surround
	zvm_bindkey vicmd "hW"  select-in-blank-word
	zvm_bindkey vicmd "h["  zvm_select_surround
	zvm_bindkey vicmd "h]"  zvm_select_surround
	zvm_bindkey vicmd "h\`" zvm_select_surround
	zvm_bindkey vicmd "ha"  select-in-shell-word
	zvm_bindkey vicmd "hw"  select-in-word
	zvm_bindkey vicmd "h{"  zvm_select_surround
	zvm_bindkey vicmd "h}"  zvm_select_surround
	zvm_bindkey vicmd "e"   down-line
	zvm_bindkey vicmd "i"   up-line
	zvm_bindkey vicmd "k"   zvm_exchange_point_and_mark

	# zvm viins (insert) mode
	zvm_bindkey vicmd 'h' zvm_enter_insert_mode
	zvm_bindkey vicmd 'H' zvm_insert_bol

	# zvm other key bindings
	zvm_bindkey visual 'k' zvm_exchange_point_and_mark
	zvm_bindkey vicmd  'k' zvm_open_line_below
	zvm_bindkey vicmd  'K' zvm_open_line_above
}
# }}}
