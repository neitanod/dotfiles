# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

function gd()
{
 $HOME/bin/gd $*
 RESULT=`cat $HOME/gotopath`
 $RESULT
}

function ga()
{
 $HOME/bin/ga $*
 RESULT=`cat $HOME/gotopath`
 cd $RESULT
}




function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

function proml {
  local         BLUE="\[\033[0;34m\]"
  local          RED="\[\033[0;31m\]"
  local    LIGHT_RED="\[\033[1;31m\]"
  local        GREEN="\[\033[0;32m\]"
  local  LIGHT_GREEN="\[\033[1;32m\]"
  local        WHITE="\[\033[1;37m\]"
  local   LIGHT_GRAY="\[\033[0;37m\]"
  local       YELLOW="\[\033[0;33m\]"
  local LIGHT_YELLOW="\[\033[1;33m\]"
  local      DEFAULT="\[\033[0m\]"
  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\u@\h:\w\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac
PS1="${TITLEBAR}\
\u@\h:$YELLOW\w$LIGHT_RED\$(parse_git_branch)\
$WHITE\$$DEFAULT "
PS2='> '
PS4='+ '
}

proml




TERM="xterm-256color"

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"



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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

PATH=~/doc/prj/go/bin/go-1.15.6/bin:$PATH:~/bin:~/bin/guybrush:~/bin/mapsentry:~/vimconfig/bin
export PATH
export LESS='-R'
export LESSOPEN='|~/.lessfilter %s'
export SYMFONY_FORCE_COLORS=TRUE

# alias vim="vim --servername VIM"
alias :q="exit"
alias :Q="exit"
alias :e="vim"
alias :Ex="vim ."
alias :tabnew="tmux -2 new-window"
alias :vsp="tmux -2 split-window -h"
alias :sp="tmux -2 split-window"
alias tmuxc="vim ~/.tmux.conf"
alias bashrc="vim ~/.bashrc"

alias :w="tmux command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -S -32768 ; save-buffer %1 ; delete-buffer ; new-window \"vim %1\" '"
# alias :w="tmux 'capture-pane -S -32768 ; save-buffer ~/tmux.history ; delete-buffer ; new-window \"vim ~/tmux.history\"'"
if [ -f ~/.fzf.bash ]; then
source ~/.fzf.bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias publish="curl -F file=@- https://publish.ip1.cc"
pactl unload-module module-device-manager > /dev/null 2>&1
