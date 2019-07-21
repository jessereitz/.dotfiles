# Open the file manager (taken from Mac)
function open() {
  if [ $OS_ENV == "Linux" ]; then
    nautilus $* &
  else
    open $* &
  fi
}


# Backup/Restore Gnome terminal
function terminal() {
  if [ ! $OS_ENV == "Linux" ]; then
    echo "This isn't Linux. Don't even try."
    exit
  fi

  settings_file=~/.gnome_terminal_settings.txt
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

function oprah() {
  GIT_ROOT=$(git rev-parse --show-toplevel)
  docker run \
    --rm \
    --volume "$GIT_ROOT:/app" \
    --volume "$HOME/.gitconfig:/root/.gitconfig" \
    ordoro/legithub:latest "$@"
}

function flushdns() {
  sudo killall -HUP mDNSResponder
}

function jesseco() {
  echo 563955
  echo 563955 | pbcopy
}

function up {
  times=$1
  while [ "$times" -gt 0 ]; do
    cd ..
    times=$(($times -1))
  done
}

function activate_mack() {
 source /Users/jessereitz/integrations/mackerel/.env/bin/activate
}

function connect_db() {
  psql -U jesse -d ordoro -h localhost -p 5489
}

function connect_mack_server() {
  ssh jesse@whistlepig.aws-prod.ordoro.com
}

function snakefood() {
  sfood . | sfood-graph | dot -Tps | pstopdf -i
}

function shrug() {
  echo '¯\_(ツ)_/¯' 
  echo '¯\_(ツ)_/¯' | pbcopy
}
