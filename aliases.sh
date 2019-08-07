alias ll="ls -lah"
alias l="ls"
alias wp='ssh whistlepig.aws-prod.ordoro.com'
#alias wpo='ssh ordorodeployer@whistlepig.aws-prod.ordoro.com'
alias ccat="source-highlight --out-format=esc256 -o STDOUT -i"
#alias ctags="/usr/local/Cellar/ctags/5.8_1/bin/ctags"
alias exe="chmod +x $1"
alias getip="curl icanhazip.com"

if [ $OS_ENV == "Linux" ]; then
  alias open="xdg-open"
fi
