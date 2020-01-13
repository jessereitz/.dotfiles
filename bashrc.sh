source ~/.bash_settings/aliases.sh
source ~/.bash_settings/colors.sh

############################################################
# Source some git stuff
############################################################
if [ -f ~/.bash_settings/git-completion.bash ]; then
    . ~/.bash_settings/git-completion.bash
fi

if [ -f ~/.bash_settings/git-prompt.sh ]; then
    . ~/.bash_settings/git-prompt.sh
fi


############################################################
# Set some global variables
############################################################

# Determine which OS we're using -> useful for aliasing
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     OS_ENV=Linux;;
    Darwin*)    OS_ENV=Mac;;
    *)          OS_ENV="UNKNOWN:${unameOut}";;
esac
export OS_ENV=$OS_ENV


############################################################
# Set some global variables
############################################################

# Backup/Restore Gnome terminal
function terminal() {
    if [ ! $OS_ENV == "Linux" ]; then
        echo "This isn't Linux. Don't even try."
        exit
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
