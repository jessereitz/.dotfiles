eval $(/opt/homebrew/bin/brew shellenv)
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

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

# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle :compinstall filename '/Users/${USER}/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

autoload -U select-word-style
select-word-style bash

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/${USER}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
# ZSH_THEME="clean"
# ZSH_THEME="essembeh"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"


# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git pyenv virtualenv nvm)

source $ZSH/oh-my-zsh.sh

# PROMPT STUFF
function my_git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
	echo "%{$fg[white]%}(%{$fg[green]%}${ref#refs/heads/}$GIT_STATUS%{$fg[white]%})%{$reset_color%}"
}

virtualenv_prompt_info () {
    empty_pyenv="pyenv: no local version configured for this directory"
    pyenv_local=$(pyenv local 2>&1)
    if test "$pyenv_local" = "$empty_pyenv" ; then
        PYTHON_VIRTUALENV="";
    else
        # PYTHON_VIRTUALENV=$pyenv_local
        PYTHON_VIRTUALENV="${reset_color}[%{$fg[magenta]%}$(basename "$pyenv_local")${reset_color}] "
    fi
    echo $PYTHON_VIRTUALENV
}

if [ -z "$DISPLAY_HOSTNAME" ]; then
    DISPLAY_HOSTNAME=$(hostname)
fi
# Colored prompt
ZSH_THEME_NAME="%{$fg[cyan]%}%n"
ZSH_THEME_HOST="%{$fg[green]%}$DISPLAY_HOSTNAME"
ZSH_THEME_PWD="%{$fg[yellow]%}%~%{$reset_color%}"
PROMPT='$(virtualenv_prompt_info)$ZSH_THEME_NAME%{$reset_color%}@$ZSH_THEME_HOST%{$reset_color%}:$ZSH_THEME_PWD $(my_git_prompt_info)%% '
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



unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
        OS_ENV=Linux
        ;;
    Darwin*)
        OS_ENV=Darwin
        ;;
    *)
        OS_ENV="UNKNOWN:${unameOut}"
        ;;
esac
export OS_ENV=$OS_ENV
# export ZSH_CONFIG="$HOME/.dotfiles"
# export CONFIG_FILE="$HOME/$_config_file"

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
alias -g pip='pip3'
alias -g cod='code'  # I'm bad at spelling
alias -g gti='git'
alias -g resource='. $HOME/.zshrc'

###################################################################

# Backup/Restore Gnome terminal
terminal() {
    if [ ! "$OS_ENV" = "Linux" ]; then
        echo "This isn't Linux. Don't even try."
        return
    fi

    settings_file=$BASH_CONFIG/terminal_configs/gnome_terminal_settings.txt
    action=$1

    case "$action" in
        backup)     ;;
        load)       ;;
        *)          action="ERR";;
    esac

    if [ $action = "ERR" ]; then
        echo "Invalid action ${action}."
        echo "Usage: terminal [action=backup|load] <settings_file>"
    fi

    if [ $action = "backup" ]; then
        echo "Saving Gnome terminal settings to ${settings_file}"
        dconf dump /org/gnome/terminal/ > "$settings_file"
        echo "Done."
    fi

    if [ $action = "load" ]; then
        custom_settings_file=$2
        if [ -z "$custom_settings_file" ]; then
            echo "No settings file provided. Using default $settings_file"
        else
            settings_file=$custom_settings_file
        fi

        echo "Resetting settings."
        dconf reset -f /org/gnome/terminal/

        echo "Loading custom settings."
        dconf load /org/gnome/terminal/ < "$settings_file"
    fi
}

flushdns() {
    if [ "$OS_ENV" = "Darwin" ]; then
        sudo killall -HUP mDNSResponder
        return
    fi
    sudo systemd-resolve --flush-caches
    sudo systemctl restart systemd-resolved.service
}

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

pullit() {
    pushit &&
    prettypull
}

vboxip() {
    # List all IP addresses of running VirtualBox VMs -> https://superuser.com/a/1530741
    for VM in $(VBoxManage list runningvms | awk -F\{ '{print $2}' | sed -e 's/}//g');
    do {
        VMNAME="$(VBoxManage showvminfo "$VM" --machinereadable | awk -F= '/^name/{print $2}')"
        VMIP=$(VBoxManage guestproperty get "$VM" "/VirtualBox/GuestInfo/Net/0/V4/IP" | sed -e 's/Value: //g')
        printf "VM-IP: %-16s VM-Name: %-50s\n" "$VMIP" "$VMNAME"
    } done
}

newvenv() {
    venv_name=$1

    if [ -z "$venv_name" ]; then
        venv_name=$(basename "$PWD")
    fi

    echo "creating virtual environment: $venv_name"

    if command -v pyenv 1>/dev/null 2>&1; then
        pyenv virtualenv 3.6.11 "$venv_name" || { echo "failed to create virtualenv"; return 1; }
        echo "$venv_name" > .python-version
    else
        virtualenv -p python3 "$venv_name" || { echo "failed to created virtualenv"; return 1; }
        # shellcheck source=/dev/null
        . "./$venv_name/bin/activate"
    fi
}

fnd() {
    find ./ -name "$1"
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

export PYTHONDONTWRITEBYTECODE=1
