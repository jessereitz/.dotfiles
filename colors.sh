export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad

bash_prompt() {
    local Red='\[\e[0;31m\]'; local BRed='\[\e[1;31m\]'
    local Gre='\[\e[0;32m\]'; local BGre='\[\e[1;32m\]'
    local Yel='\[\e[0;33m\]'; local BYel='\[\e[1;33m\]'
    local Blu='\[\e[0;34m\]'; local BBlu='\[\e[1;34m\]'
    local Mag='\[\e[0;35m\]'; local BMag='\[\e[1;35m\]'
    local Cya='\[\e[0;36m\]'; local BCya='\[\e[1;36m\]'
    local Whi='\[\e[0;37m\]'; local BWhi='\[\e[1;37m\]'
    local None='\[\e[0m\]'

    local GIT_PS1_SHOWDIRTYSTATE=True
    local GIT_PS1_SHOWSTASHSTATE=True
    local GIT_PS1_SHOWCOLORHINTS=True
    local GIT_PS1_SHOWUNTRACKEDFILES=True

    __git_ps1 "$Cya\u$None@$Gre\h:$Yel\w$None" "$None$ "
}



PROMPT_COMMAND=bash_prompt

