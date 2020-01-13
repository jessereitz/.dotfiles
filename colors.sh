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
