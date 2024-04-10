eval $(/opt/homebrew/bin/brew shellenv)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
export PATH="$HOME/.dotfiles/own_scripts:$PATH"

######################################################################
# ZSH Setup
######################################################################
setopt NO_CASE_GLOB
setopt AUTO_CD

# Correct me please
setopt CORRECT
setopt CORRECT_ALL

# Configure ZSH history
setopt EXTENDED_HISTORY # store additinoal info in .zsh_history
setopt SHARE_HISTORY # share history across sessions
setopt APPEND_HISTORY # append to history instead of overwriting it
setopt INC_APPEND_HISTORY # immediately append commands to history instead of waiting for exit
setopt HIST_EXPIRE_DUPS_FIRST # clean up duplicate commands first
setopt HIST_IGNORE_DUPS # don't even store duplicates
setopt HIST_FIND_NO_DUPS # ignore duplicates when searching
setopt HIST_REDUCE_BLANKS # remove blank lines from history
setopt HIST_VERIFY # command substitutions, eg sudo !!

SAVEHIST=500000
HISTSIZE=500000
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/${USER}/.zshrc'
autoload -Uz compinit
compinit

autoload -U select-word-style
select-word-style bash

######################################################################
# Python Setup
######################################################################
export PYTHONDONTWRITEBYTECODE=1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if foobar_loc="$(type -p "pyenv")" || [[ -z $foobar_loc ]]; then
    # install foobar here
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

######################################################################
# Oh-My-ZSH Setup
######################################################################
# Path to your oh-my-zsh installation.
export ZSH="/Users/${USER}/.oh-my-zsh"
DISABLE_UPDATE_PROMPT=true
ENABLE_CORRECTION="true"
plugins=(git pyenv)
source $ZSH/oh-my-zsh.sh

# PROMPT STUFF
function my_git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
	echo "%{$fg[green]%}git:(%{$fg[yellow]%}${ref#refs/heads/}$GIT_STATUS%{$fg[green]%})%{$reset_color%}"
}

function python_virtualenv_info() {
    if (( ${+VIRTUAL_ENV} )); then
        echo "%{$fg[yellow]%}${VIRTUAL_ENV:t}%{$reset_color%}"
    fi
}

if [ -z "$DISPLAY_HOSTNAME" ]; then
    DISPLAY_HOSTNAME=$(hostname) 
    DISPLAY_HOSTNAME="${${(%):-%M}%.local}"
fi
# Colored prompt
ZSH_THEME_NAME="%{$fg[cyan]%}%n"
ZSH_THEME_HOST="%{$fg[green]%}$DISPLAY_HOSTNAME"
ZSH_THEME_PWD="%{$fg[yellow]%}%~%{$reset_color%}"
PROMPT='$(python_virtualenv_info) $ZSH_THEME_NAME%{$reset_color%}@$ZSH_THEME_HOST%{$reset_color%}:$ZSH_THEME_PWD $(my_git_prompt_info)%% '
export VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%}) %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}%%"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}$"

######################################################################
# Aliases: A simple affair
######################################################################
alias -g ll='ls -lah -G'
alias -g l='ls -G'
alias -g less='less -R'
alias -g ccat='source-highlight --out-format=esc256 -o STDOUT -i'
alias -g getip='curl icanhazip.com'
alias -g py='python'
alias -g py3='python3'
alias -g python='python3'
alias -g pip='pip3'
alias -g cod='code'  # I'm bad at spelling
alias -g gti='git'
alias -g resource='. $HOME/.zshrc'

###################################################################

up() {
    # Go up a number of directories while preserving directory history
    # EG. `up 3 => cd ../../../.`
    target_path='.'
    times=${1:-'1'}
    while [ "$times" -gt 0 ]; do
        target_path="../${target_path}"
        times=$((times -1))
    done
    cd $target_path || return
}

shrug() {
    echo "¯\_(ツ)_/¯"
    printf "¯\_(ツ)_/¯" | pbcopy
}

gitter() {
    # Clean up after a PR merge -> pull changes, switch to target branch, delete current branch
    TARGET_BRANCH=$1
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD | awk '{$1=$1;print}')


    if [ -z "$TARGET_BRANCH" ]; then
        TARGET_BRANCH=$(git remote show origin | grep "HEAD branch" | cut -d ":" -f 2 | awk '{$1=$1;print}')
    fi

    echo "Target branch: ${TARGET_BRANCH}; Current branch: ${CURRENT_BRANCH}"
    if [ "$TARGET_BRANCH" = "$CURRENT_BRANCH" ]; then
        echo "Current branch ${CURRENT_BRANCH} is the same as target ${TARGET_BRANCH}. Exiting."
        return 1
    fi

    echo "Pull recent changes to ${TARGET_BRANCH}, deleting current branch ${CURRENT_BRANCH}"
    git co "$TARGET_BRANCH" &&
    git pull &&
    git br -d "$CURRENT_BRANCH"
}

pushit() {
    git push -u origin HEAD
}

dockerkillall() {
    echo "Killing all running docker containers"
    for ctn_id in $(docker ps -q);
    do {
        echo "killing $ctn_id"
        docker kill "$ctn_id"
    } done;
    echo "All running containers killed"
}
