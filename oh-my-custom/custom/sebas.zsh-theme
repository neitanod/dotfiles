# ZSH theme by Sebastian Grignoli, based on the "intheloop" theme by James Smith (http://loopj.com)
# A single line prompt with username, hostname, full path, return status, git branch, git dirty status, git remote status

local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"

local host_color="white"
if [ -n "$SSH_CLIENT" ]; then
  local host_color="red"
fi

PROMPT='%{$fg_bold[grey]%}%{$reset_color%}%{$fg_bold[${host_color}]%}%n@%m%{$reset_color%}%{$fg_bold[grey]%}:%{$reset_color%}%{$fg[yellow]%}%10c%{$reset_color%}$(git_prompt_prefix)$(git_prompt_branch)$(parse_git_dirty)$(git_remote_status)$(git_prompt_suffix)%{$fg_bold[white]%}$%{$reset_color%} '

RPROMPT='${return_status}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[grey]%} %{$fg_bold[red]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[red]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}%1{⚡%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[grey]%}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[magenta]%}%1{↓%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[magenta]%}%1{↑%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[magenta]%}%1{↕%}%{$reset_color%}"
