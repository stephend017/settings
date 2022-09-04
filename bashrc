# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
source "$DIR/settings/colors.sh"
source "$DIR/settings/git_util.sh"

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

set -o vi

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# function to flip a coin when needing to make a 50/50 decision
coinFlip() {
    COIN=$(($RANDOM%2))
    if [[ $COIN -eq 1 ]]; then
        echo "HEADS"
    else
        echo "TAILS"
    fi
}

# color prompt function
# creates a prompt in the following format
# <working directory>
# <local-time> <user> <git branch> <git status> 
# TODO 
function set_colored_PS1 {
    PS1="\[${BG_SECONDARY}${FG_SECONDARY}\] \w \[$(reset_colors)\]"
    if [[ $(inside_git_repo) ]]; then 
        gs=$(git status)
        ghtf=$(git_has_untracked_files "$gs")
        ghuc=$(git_has_unstaged_files "$gs")
        ghsf=$(git_has_staged_files "$gs")
        ghcf=$(git_has_committed_files "$gs")
        
        PS1+="\[$(git_branch_bg_color "$ghtf" "$ghuc" "$ghsf" "$ghcf")$(git_branch_fg_color "$ghtf" "$ghuc" "$ghsf" "$ghcf")\] $(git_branch "$gs") \[$(reset_colors)\]"

        if [[ $ghtf -gt 0 ]]; then 
            PS1+="\[${BG_ERROR}${FG_ERROR}\] + \[$(reset_colors)\]"
        fi
        if [[ $ghuc -gt 0 ]]; then 
            PS1+="\[${BG_ERROR}${FG_ERROR}\] ! \[$(reset_colors)\]"
        fi
        if [[ $ghsf -gt 0 ]]; then 
            PS1+="\[${BG_WARNING}${FG_WARNING}\] ✓ \[$(reset_colors)\]"
        fi
        if [[ $ghcf -gt 0 ]]; then 
            PS1+="\[${BG_SUCCESS}${FG_SUCCESS}\] ✓ \[$(reset_colors)\]"
        fi
    fi
    PS1+="\n"
    # set user
    PS1+="\[${BG_PRIMARY}${FG_PRIMARY}\] \u \[$(reset_colors)\] "

    RIGHT="\[${BG_HIDDEN}\] \t "
    local Save='\e[s' # Save cursor position
    local Rest='\e[u' # Restore cursor to save point
    
    PS1="\[${Save}\]\e[${COLUMNS:-$(tput cols)}C\e["10"D${RIGHT}\[${Rest}\]${PS1}"
}


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
# ! original setting
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    set_colored_PS1
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias dc='docker-compose'
alias dcb='docker-compose build'
alias dcu='docker-compose up'
alias dcd='docker-compose down'

alias droplet-root='ssh root@204.48.31.202'
alias droplet='ssh sed@204.48.31.202'


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

PROMPT_COMMAND=set_colored_PS1


# set environment variables
# source /etc/environment
