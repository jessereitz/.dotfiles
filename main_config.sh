#!/bin/sh
######################################################################
# Jesse R's Shell Profile:
#
# Some settings I like. I only use MacOS and Ubuntu-derivatives so
# this is tailor-made for that.
#
#     https://github.com/jessereitz/.dotfiles
#
######################################################################

######################################################################
# Global Variables: Some convenient settings and values
######################################################################
export PYTHONDONTWRITEBYTECODE=1  # bye-bye __pycache__
export EDITOR=vim

# Determine which OS we're using -> useful for same aliases on different machines
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)
        OS_ENV=Linux
        _config_file=.bashrc
        ;;
    Darwin*)
        OS_ENV=Darwin
        _config_file=.bash_profile
        ;;
    *)
        OS_ENV="UNKNOWN:${unameOut}"
        ;;
esac
export OS_ENV=$OS_ENV
export BASH_CONFIG="$HOME/.dotfiles"
export CONFIG_FILE="$HOME/$_config_file"

######################################################################
# Aliases: A simple affair
######################################################################
alias ll='ls -lah -G'
alias l='ls -G'
alias less='less -R'
alias ccat='source-highlight --out-format=esc256 -o STDOUT -i'
alias getip='curl icanhazip.com'
alias py='python'
alias py3='python3'
alias pip='pip3'
alias cod='code'  # I'm bad at spelling
alias gti='git'
alias gopen="hub browse"
alias resource='. $CONFIG_FILE'

if [ "$OS_ENV" = "Linux" ]; then
    # I really like some of Mac's built in utilities
    alias open="xdg-open"  # Open the given directory in file manager
    alias pbcopy="xclip -selection clipboard"  # pipe input to the clipboard
    alias pbpaste="xclip -selection clipboard -o"  # pip input from the clipboard
    alias isodate="date --iso-8601=seconds"
    alias chrome='google-chrome'

    alias brew="/home/linuxbrew/.linuxbrew/bin/brew"
else
    # Mac is dumb and doesn't include stuff...
    alias isodate="date +%Y-%m-%dT%H:%M:%S%z"
    alias brew="/usr/local/bin/brew"
    alias chrome="open -a Google\ Chrome --args"
fi


######################################################################
# Functions: A more complicated affair
######################################################################

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
    echo "¯\_(ツ)_/¯" | pbcopy
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
        venv_name=.env
    fi

    echo "creating virtual environment: $venv_name"
    virtualenv -p python3 "$venv_name" || echo "failed to created virtualenv"; return 1
    # shellcheck source=/dev/null
    . "./$venv_name/bin/activate"
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

######################################################################
# Colors and Prompt: a more palatable command line
######################################################################
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

# SC2034 -> unused var
# I don't care if these are unused, I want them around
# shellcheck disable=SC2034
Red='\[\e[0;31m\]'
# shellcheck disable=SC2034
BRed='\[\e[1;91m\]'
# shellcheck disable=SC2034
Gre='\[\e[0;32m\]'
# shellcheck disable=SC2034
BGre='\[\e[1;92m\]'
# shellcheck disable=SC2034
Yel='\[\e[0;33m\]'
# shellcheck disable=SC2034
BYel='\[\e[1;93m\]'
# shellcheck disable=SC2034
Blu='\[\e[0;34m\]'
# shellcheck disable=SC2034
BBlu='\[\e[1;94m\]'
# shellcheck disable=SC2034
Mag='\[\e[0;35m\]'
# shellcheck disable=SC2034
BMag='\[\e[1;95m\]'
# shellcheck disable=SC2034
Cya='\[\e[0;36m\]'
# shellcheck disable=SC2034
BCya='\[\e[1;96m\]'
# shellcheck disable=SC2034
Whi='\[\e[0;37m\]'
# shellcheck disable=SC2034
BWhi='\[\e[1;97m\]'
# shellcheck disable=SC2034
None='\[\e[0m\]'


# Set up my bash prompt with py virtualenv and some git info
set_virtualenv () {
    if test -z "$VIRTUAL_ENV" ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="${None}[$Mag$(basename \""$VIRTUAL_ENV")$None] "
    fi
}

bash_prompt() {
    set_virtualenv
    if [ -z "$DISPLAY_HOSTNAME" ]; then
        DISPLAY_HOSTNAME=$(hostname)
    fi
    export GIT_PS1_SHOWDIRTYSTATE=True
    export GIT_PS1_SHOWSTASHSTATE=True
    export GIT_PS1_SHOWCOLORHINTS=True
    export GIT_PS1_SHOWUNTRACKEDFILES=True

    __git_ps1 "$PYTHON_VIRTUALENV$Cya\u$None@$Gre$DISPLAY_HOSTNAME:$Yel\w$None" "$None$ "
}

PROMPT_COMMAND=bash_prompt

######################################################################
# Third Party Scripts: some people just do it better
######################################################################
if [ -f "$BASH_CONFIG"/third_party/git-completion.bash ]; then
    # shellcheck source=/dev/null
    . "$BASH_CONFIG"/third_party/git-completion.bash
fi

if [ -f "$BASH_CONFIG"/third_party/git-prompt.sh ]; then
    # shellcheck source=/dev/null
    . "$BASH_CONFIG"/third_party/git-prompt.sh
fi
