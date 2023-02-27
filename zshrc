# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh configuration.
ZSH=$HOME/dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
ZSH_THEME="sebas"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git k artisan) # (git k zsh-nvm)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export GOROOT=$HOME/doc/prj/go/bin/go-1.15.6/
export GOPATH=/home/sebas/doc/prj/go/

export PATH=$PATH:${GOROOT}bin:/home/sebas/bin:/home/sebas/bin/mapsentry:/home/sebas/bin/guybrush:/home/sebas/vimconfig/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/sebas/bin

#export MAIL_DRIVER=log

unsetopt auto_name_dirs
unsetopt autonamedirs

export TERM=xterm-256color

function gd()
{
 $HOME/bin/gd $*
  `cat $HOME/.gotopath`
}

function ga()
{
 $HOME/bin/ga $*
  `cat $HOME/.gotopath`
}

[[ -n "${key[Up]}"      ]] && bindkey  "${key[Up]}"      history-beginning-search-backward
[[ -n "${key[Down]}"    ]] && bindkey  "${key[Down]}"    history-beginning-search-forward

if [ -f ~/.fzf.zsh ]; then
source ~/.fzf.zsh
fi

which setxkbmap | grep "not found" > /dev/null;
returned=$?; if [[ $returned != 0 ]]; then
    setxkbmap -option
fi

# export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
#

# Nodejs
#VERSION=v10.16.0
VERSION=v14.17.1
DISTRO=linux-x64
export PATH=/usr/local/lib/nodejs/node-$VERSION-$DISTRO/bin:$PATH

.  ~/apps/extraterm-0.36.2-linux-x64/extraterm-commands-0.36.2/setup_extraterm_zsh.zsh 2>/dev/null

alias publish="curl -F file=@- https://publish.ip1.cc"
alias publishcolor="publish | template https://ansi.ip1.cc/\#\{@\}"

command -v bat &> /dev/null && alias cat='bat --paging=never'

# cd.. for old Windows and DOS compatibility
alias cd..="cd .."

# disable stderr in red color for now (didn't like it)
# LIBSTDERRED=~/apps/stderred/build/libstderred.so
# if [ -f $LIBSTDERRED ]; then
#     export LD_PRELOAD="$LIBSTDERRED${LD_PRELOAD:+:$LD_PRELOAD}"
# fi

# OPAM configuration
. /home/sebas/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

if [ -f  $HOME/.asdf/asdf.sh ]; then . $HOME/.asdf/asdf.sh; fi

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/sebas/apps/google-cloud-sdk/path.zsh.inc' ]; then . '/home/sebas/apps/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/sebas/apps/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/sebas/apps/google-cloud-sdk/completion.zsh.inc'; fi

source ~/dotfiles/oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
