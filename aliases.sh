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
