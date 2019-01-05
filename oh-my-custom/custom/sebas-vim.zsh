# Aliases para controlar el shell y el tmux como si fueran el Vim

alias :q='exit' 
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
alias lls="ls -la | lolcat"
alias :w="tmux command-prompt -p 'save history to filename:' -I '~/tmux.history' 'capture-pane -S -32768 ; save-buffer %1 ; delete-buffer ; new-window \"vim %1\" '"

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
