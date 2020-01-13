######################################################################
# Jesse R's Bash Profile:
#
# Some settings I like. I only use MacOS and Ubuntu-derivatives so
# this is tailor-made for that.
#
#     https://github.com/jessereitz/mac_bash
#
######################################################################

######################################################################
# Global Variables: Some convenient settings and values
######################################################################

# Determine which OS we're using -> useful for same aliases on different machines
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OS_ENV=Linux;;
    Darwin*)    OS_ENV=Mac;;
    *)          OS_ENV="UNKNOWN:${unameOut}";;
esac
export OS_ENV=$OS_ENV
export BASH_CONFIG="${HOME}/.bash_settings"
# TODO: use .dotfiles instead of .bash_settings
# export BASH_CONFIG="${HOME}/.dotfiles"

######################################################################
# Aliases: A simple affair
######################################################################
alias ll="ls -lah"
alias l="ls"
alias wp='ssh whistlepig.aws-prod.ordoro.com'
alias ccat="source-highlight --out-format=esc256 -o STDOUT -i"
alias exe="chmod +x $1"
alias getip="curl icanhazip.com"
alias py="python"
alias py3="python3"
alias pip="pip3"
alias cod="code"
alias gti="git"

if [ $OS_ENV == "Linux" ]; then
  alias open="xdg-open"
  alias pbcopy="xclip -selection clipboard"
  alias pbpaste="xclip -selection clipboard -o"
fi


######################################################################
# Functions: A more complicated affair
######################################################################

# Backup/Restore Gnome terminal
function terminal() {
    if [ ! $OS_ENV == "Linux" ]; then
        echo "This isn't Linux. Don't even try."
        return
    fi

    settings_file=~/.bash_settings/gnome_terminal_settings.txt
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
        dconf dump /org/gnome/terminal/ > $settings_file
        echo "Done."
    fi

    if [ $action = "load" ]; then
        custom_settings_file=$2
        if [ -z $custom_settings_file ]; then
            echo "No settings file provided. Using default $settings_file"
        else
            settings_file=$custom_settings_file
        fi

        echo "Resetting settings."
        dconf reset -f /org/gnome/terminal/

        echo "Loading custom settings."
        dconf load /org/gnome/terminal/ < $settings_file
    fi
}

function flushdns() {
    if [ ! $OS_ENV == "Linux" ]; then
        sudo killall -HUP mDNSResponder
        return
    fi
    sudo systemd-resolve --flush-caches
}

function up() {
    # Go up a number of directories while preserving directory history
    # EG. `up 3 => cd ../../../.`
    target_path='.'
    times=$1
    while [ "$times" -gt 0 ]; do
        target_path="../${target_path}"
        times=$(($times -1))
    done
    cd $target_path
}

function shrug() {
    echo '¯\_(ツ)_/¯'
    echo '¯\_(ツ)_/¯' | pbcopy
}

function gitter {
    current_branch=`git rev-parse --abbrev-ref HEAD`

    echo "Pull recent changes to master, deleting current branch ${current_branch}"
    git co master &&
    git pull &&
    git br -d $current_branch
}

######################################################################
# Colors: a more palatable command line
######################################################################
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

Red='\[\e[0;31m\]'; BRed='\[\e[1;91m\]'
Gre='\[\e[0;32m\]'; BGre='\[\e[1;92m\]'
Yel='\[\e[0;33m\]'; BYel='\[\e[1;93m\]'
Blu='\[\e[0;34m\]'; BBlu='\[\e[1;94m\]'
Mag='\[\e[0;35m\]'; BMag='\[\e[1;95m\]'
Cya='\[\e[0;36m\]'; BCya='\[\e[1;96m\]'
Whi='\[\e[0;37m\]'; BWhi='\[\e[1;97m\]'
None='\[\e[0m\]'

function set_virtualenv () {
    if test -z "$VIRTUAL_ENV" ; then
        PYTHON_VIRTUALENV=""
    else
        PYTHON_VIRTUALENV="$None[$Mag`basename \"$VIRTUAL_ENV\"`$None] "
    fi
}

bash_prompt() {
    set_virtualenv

    local GIT_PS1_SHOWDIRTYSTATE=True
    local GIT_PS1_SHOWSTASHSTATE=True
    local GIT_PS1_SHOWCOLORHINTS=True
    local GIT_PS1_SHOWUNTRACKEDFILES=True

    __git_ps1 "$PYTHON_VIRTUALENV$Cya\u$None@$Gre\h:$Yel\w$None" "$None$ "
}

PROMPT_COMMAND=bash_prompt


######################################################################
# Initial Configuration: set some stuff up
######################################################################
function gitconfig {
    echo "Copying global gitconfig"
    cat ./.gitconfig >> ~/.gitconfig
    echo "Done copying global gitconfig"
}

function setup_vim {
    if [ -d ~/.vim ]; then
        echo "Removing old vim config"
        rm -rf ~/.vim
    fi
    echo "Initializing vim"
    cp -r $BASH_CONFIG/.vim ~/.vim
    echo "Installing vim plugins"
    vim +PlugInstall +qall
    echo "Done initializing vim"
}

function initialize_all {
    echo "Initializing bash and vim settings"
    gitconfig
    setup_vim
    echo "Done."
}

######################################################################
# Third Party Scripts: some people just do it better
######################################################################
if [ -f ~/.bash_settings/git-completion.bash ]; then
    . ~/.bash_settings/git-completion.bash
fi

if [ -f ~/.bash_settings/git-prompt.sh ]; then
    . ~/.bash_settings/git-prompt.sh
fi