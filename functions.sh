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

function up {
  times=$1
  while [ "$times" -gt 0 ]; do
    cd ..
    times=$(($times -1))
  done
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
