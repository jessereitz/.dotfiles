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
