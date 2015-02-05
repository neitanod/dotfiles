# Funciones auxiliares para poder parsear el prompt como me gusta a mi

function git_prompt_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

function git_prompt_prefix() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX"
}

function git_prompt_suffix() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

alias diff='git difftool -g -y & ' 
alias cola='git-cola & ' 
alias gitcal='git-cal ' 
alias push='git push '
alias pull='git pull '
alias merge='git merge '
alias st='git st '
alias ci='git ci '
